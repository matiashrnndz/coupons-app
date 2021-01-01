class PromotionsController < ApplicationController
  before_action :authorize_admin

  def new
    @promo_definition = PromotionDefinition.find(params[:promotion_definition_id])
  end

  def create
    quantity = params[:promotion][:quantity].to_i
    promotion_definition_id = params[:promotion_definition_id]
    CouponGeneratorWorker.perform_async(quantity, promotion_definition_id)
    flash[:success] = 'Generating coupons...'
    redirect_to root_path
  end

  def index
    @promo_definition = PromotionDefinition.find(params[:promotion_definition_id])
    @promotions = @promo_definition.promotions
  end

  private

  def promotion_definition_params
    params.require(:promotion_definition).permit(:name, :discount_type, :value, :promotion_state,
                                                 :promotion_type, :promotion_attributes, :conditions)
  end
end
