class ClientPromotionsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authorize_request, except: %i[generate_token new_token]
  before_action :authorize_admin, only: %i[generate_token new_token]
  before_action :set_promo, except: %i[generate_token new_token]

  def evaluation
    @start_time = Time.zone.now
    if @promo.promotion_state == 'active'
      @metadata = params[:metadata]
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
    @token = params[:token]
  end

  def generate_token
    codes = params[:token][:codes]
    name = params[:token][:name]
    @new_token = JwtService.encode(codes: codes, name: name)
    @time = Time.zone.now + 24.hours.to_i
    render :new_token
  end

  private

  def generate_logic_expression
    aux_condition = @promo.conditions
    attr_list = @metadata[:attributes]
    attr_list.each do |attribute, value|
      aux_condition = aux_condition.gsub(attribute, value.to_s)
    end
    aux_condition
  end

  def create_promotion_report(successful, spent_amount = 0)
    finish_time = Time.zone.now
    response_time = (finish_time - @start_time) * 1000
    PromotionReport.create(promotion_definition: @promo, successful: successful,
                           spent_amount: spent_amount, response_time: response_time)
  end

  def evaluate_coupon
    coupon = @promo.promotions.find_by(code: @metadata[:coupon_code])
    if coupon && !coupon.used
      conditions = generate_logic_expression
      valid_conditions = LogicExpressionValidatorService.new.validate_logic_expression(conditions)
      if valid_conditions
        coupon.used = true
        coupon.save
        spent_amount = calculate_spent(@total)
        create_promotion_report(true, spent_amount)
        render json: { success: 'Valid promotion' }, status: :ok and return
      else
        create_promotion_report(false)
        render json: { errors: 'Invalid promotion' }, status: :unprocessable_entity and return
      end
    else
      create_promotion_report(false)
      render json: { errors: 'Invalid coupon' }, status: :unprocessable_entity and return
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
          Promotion.create(promotion_definition: @promo, used: true, code: transaction_id)
          spent_amount = calculate_spent(@total)
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

  def authorize_request
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
