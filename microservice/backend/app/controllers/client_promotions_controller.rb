class ClientPromotionsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authorize_client_request, except: %i[generate_token new_token]
  before_action :authorize_admin, only: %i[generate_token new_token]
  before_action :set_promo, except: %i[generate_token new_token]

  def evaluation
    @start_time = Time.zone.now
    @metadata = params[:metadata]
    if @promo.expiration_date > Date.today
      if @promo.promotion_state == 'active'
        @total = @metadata[:total]
        if @total
          promo_type = @promo.promotion_type
          if promo_type == 'coupon'
            evaluate_coupon
          else
            evaluate_discount
          end
        else
          create_promotion_report(false)
          render json: { errors: 'Missing total' }, status: :unprocessable_entity and return
        end
      else
        create_promotion_report(false)
        render json: { errors: 'Inactive promotion' }, status: :unprocessable_entity and return
      end
    else
      create_promotion_report(false)
      render json: { errors: 'Promotion expired' }, status: :unprocessable_entity and return
    end
  end

  def report
    entries = PromotionReport.for_promotion(@promo)
    total_entries = entries.count
    positive_entries = entries.positive
    positive_count = positive_entries.count
    negative_count = total_entries - positive_count
    ratio = (positive_count * 100) / total_entries unless total_entries.zero?
    ratio = 0 if total_entries.zero?
    average_response_time = entries.average(:response_time) if entries.any?
    average_response_time = 0 unless entries.any?
    total_spent = positive_entries.sum(:spent_amount)
    render json: { total_calls: total_entries, successful_calls: positive_count,
                   unsuccessful_calls: negative_count, successful_ratio: ratio,
                   average_response_time: average_response_time,
                   total_spent: total_spent }, status: :ok
  end

  def new_token
    promotions = PromotionDefinitionSerializer.new(current_tenant.promotion_definitions).serializable_hash
    render json: { token: params[:token], promotion_definitions: promotions }, status: :ok
  end

  def generate_token
    codes = params[:codes]
    name = params[:name]
    @new_token = JwtService.encode(codes: codes, name: name)
    @time = Time.zone.now + 24.hours.to_i
    promotions = PromotionDefinitionSerializer.new(current_tenant.promotion_definitions).serializable_hash
    render json: { new_token: @new_token, time: @time, promotion_definitions: promotions }, status: :ok
  end

  private

  def generate_logic_expression
    aux_condition = @promo.conditions
    attr_list = @metadata[:attributes]
    attr_list[:total] = @total
    attr_list.each do |attribute, value|
      aux_condition = aux_condition.gsub(attribute, value.to_s)
    end
    aux_condition
  end

  def create_promotion_report(successful, spent_amount = 0)
    finish_time = Time.zone.now
    response_time = (finish_time - @start_time) * 1000
    report_data = {
      promotion_definition_id: @promo.id, 
      code: @promo.code,
      successful: successful,
      spent_amount: spent_amount.to_s,
      response_time: response_time,
      city: @metadata[:city],
      country: @metadata[:country],
      birth_date: @metadata[:birth_date]
    }

    conn = Bunny.new(ENV['BUNNY_URL'])
    conn.start
    channel = conn.create_channel
    queue = channel.queue('')
    exchange = channel.fanout('evaluation')
    exchange.publish(report_data.to_json)
    conn.stop
  end

  def evaluate_coupon
    coupon = @promo.promotions.find_by(code: @metadata[:coupon_code])
    if coupon
      if coupon.expiration_date > Date.today
        if coupon.uses > 0
          conditions = generate_logic_expression
          valid_conditions = LogicExpressionValidatorService.new.validate_logic_expression(conditions)
          if valid_conditions
            coupon.uses = coupon.uses - 1
            coupon.save
            spent_amount = calculate_spent(@total.to_d)
            create_promotion_report(true, spent_amount)
            render json: { success: 'Valid promotion' }, status: :ok and return
          else
            create_promotion_report(false)
            render json: { errors: 'Invalid promotion' }, status: :unprocessable_entity and return
          end
        else
          create_promotion_report(false)
          render json: { errors: 'All coupons used' }, status: :unprocessable_entity and return
        end
      else
        create_promotion_report(false)
        render json: { errors: 'Coupon has expired' }, status: :unprocessable_entity and return
      end
    else
      create_promotion_report(false)
      render json: { errors: 'Coupon not found' }, status: :unprocessable_entity and return
    end
  end

  def evaluate_discount
    transaction_id = @metadata[:transaction_id]
    if transaction_id
      transaction = @promo.promotions.find_by(code: transaction_id)
      if transaction.nil?
        conditions = generate_logic_expression
        valid_conditions = LogicExpressionValidatorService.new.validate_logic_expression(conditions)
        if valid_conditions
          Promotion.create(promotion_definition: @promo, uses: 0, expiration_date: Date.today, code: transaction_id)
          spent_amount = calculate_spent(@total.to_d)
          create_promotion_report(true, spent_amount)
          render json: { success: 'Valid promotion' }, status: :ok and return
        else
          create_promotion_report(false)
          render json: { errors: 'Invalid promotion' }, status: :unprocessable_entity and return
        end
      else
        create_promotion_report(false)
        render json: { errors: 'Transaction already processed' }, status: :unprocessable_entity and return
      end
    else
      create_promotion_report(false)
      render json: { errors: 'Invalid transaction' }, status: :unprocessable_entity and return
    end
  end

  def valid_pemissions
    @decoded[:codes].include?(params[:code])
  end

  def set_promo
    action = action_name
    @promo = PromotionDefinition.find_by(code: params[:code]) if action == 'evaluation'
    @promo = PromotionDefinition.with_deleted.find_by(code: params[:code]) if action == 'report'

    render json: { error: 'Record not found' }, status: :not_found if @promo.nil? and return
  end

  def authorize_client_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JwtService.decode(header)
      unless valid_pemissions
        render json: { errors: "You don't have permission to perform this action" },
               status: :unauthorized and return
      end
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def calculate_spent(total)
    if @promo.discount_type == 'percentage'
      total * (@promo.value.to_d / 100)
    else
      total - @promo.value
    end
  end
end
