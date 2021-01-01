class PromotionDefinitionsController < ApplicationController
  has_scope :by_state
  has_scope :by_type
  has_scope :by_name
  has_scope :by_code
  
  protect_from_forgery with: :null_session

  before_action :authenticate_user, only: %i[report]
  before_action :unauthorize_financer, only: %i[show demographic_report demographic_report_view]
  before_action :authorize_admin, except: %i[show index report]
  before_action :set_promotion_definition, only: %i[show edit update destroy report demographic_report demographic_report_view]

  def show
    render_record(PromotionDefinition, @promo_definition)
  end

  def index
    @promo_definitions = apply_scopes(current_tenant.promotion_definitions) if current_tenant
    render_record_collection(PromotionDefinition, @promo_definitions)
  end

  def new
    render json: { success: true }, status: :ok
  end

  def create
    @promo_definition = PromotionDefinition.new(name: params[:name], discount_type: params[:discount_type], value: params[:value], promotion_state: params[:promotion_state], promotion_type: params[:promotion_type], promotion_attributes: params[:promotion_attributes], conditions: params[:conditions], promotion_state: 'active', expiration_date: params[:expiration_date])
    @promo_definition.organization = current_tenant
    code = CodeGeneratorService.generate(8)
    @promo_definition.code = code
    @promo_definition.save!
    render_record(PromotionDefinition, @promo_definition)
  rescue ActiveRecord::RecordInvalid => exception
    render_unprocessable(exception.record.errors.full_messages)
  end

  def edit
    render_record(PromotionDefinition, @promo_definition)
  end

  def update
    @promo_definition.update!(name: params[:name], promotion_state: params[:promotion_state])
    render_record(PromotionDefinition, @promo_definition)
  rescue ActiveRecord::RecordInvalid => exception
    render_unprocessable(exception.record.errors.full_messages)
  end

  def destroy
    @promo_definition.destroy
    render json: { success: true }, status: :ok
  end
  
  def report
    token = JwtService.encode(codes:[@promo_definition.code])
    render json: { token: token, promotion_name: @promo_definition.name }, status: :ok
  end

  def demographic_report
    render json: { promotion_name: @promo_definition.name, promotion_id: @promo_definition.id }, status: :ok
  end

  def demographic_report_view
    token = JwtService.encode(codes:[@promo_definition.code])
    render json: { token: token, promotion_name: @promo_definition.name }, status: :ok
  end

  private

  def promotion_definition_params
    params.require(:promotion_definition).permit(:name, :discount_type, :value, :promotion_state,
                                                 :promotion_type, :promotion_attributes, :conditions)
  end

  def set_promotion_definition
    @promo_definition = PromotionDefinition.find_by(id: params[:id])
    render_not_found(PromotionDefinition) unless @promo_definition
  end
end
