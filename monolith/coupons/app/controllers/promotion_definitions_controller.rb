class PromotionDefinitionsController < ApplicationController
  has_scope :by_state
  has_scope :by_type
  has_scope :by_name
  has_scope :by_code

  before_action :authenticate_user, only: %i[show report]
  before_action :authorize_admin, except: %i[show index report]
  before_action :set_promotion_definition, only: %i[show edit update destroy report]

  def show
  end

  def index
    @promo_definitions = apply_scopes(current_tenant.promotion_definitions) if current_tenant
  end

  def new
    @promo_definition = PromotionDefinition.new
  end

  def create
    @promo_definition = PromotionDefinition.new(promotion_definition_params)
    @promo_definition.organization = current_tenant
    code = CodeGeneratorService.generate(8)
    @promo_definition.code = code
    if @promo_definition.save
      flash[:success] = 'Promotion definition created'
      redirect_to @promo_definition
    else
      flash.now[:error] = @promo_definition.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    if @promo_definition.update(promotion_definition_params)
      flash[:success] = 'Promotion definition updated'
      redirect_to @promo_definition
    else
      flash.now[:error] = @promo_definition.errors.full_messages
      render :edit
    end
  end

  def destroy
    @promo_definition.destroy
    redirect_to promotion_definitions_path, alert: 'Promotion definition deleted succesfully'
  end

  def report
    entries = PromotionReport.for_promotion(@promo_definition)
    @total_entries = entries.count
    positive_entries = entries.positive
    @positive_count = positive_entries.count
    @negative_count = @total_entries - @positive_count
    @ratio = (@positive_count * 100) / @total_entries unless @total_entries.zero?
    @ratio = 0 if @total_entries.zero?
    @average_response_time = entries.average(:response_time) if entries.any?
    @average_response_time = 0 unless entries.any?
    @total_spent = positive_entries.sum(:spent_amount)
  end

  private

  def promotion_definition_params
    params.require(:promotion_definition).permit(:name, :discount_type, :value, :promotion_state,
                                                 :promotion_type, :promotion_attributes, :conditions)
  end

  def set_promotion_definition
    @promo_definition = PromotionDefinition.find_by(id: params[:id])
    redirect_to promotion_definitions_path if @promo_definition.nil?
  end
end
