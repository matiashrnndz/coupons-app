class PromotionsController < ApplicationController
  before_action :authorize_admin

  def new
    @promo_definition = PromotionDefinition.find(params[:promotion_definition_id])
    if @promo_definition
      render_record(PromotionDefinition, @promo_definition)
    else
      render_not_found(PromotionDefinition)
    end
  end

  def create
    quantity = params[:quantity].to_i
    uses = params[:uses].to_i
    expiration_date = params[:expiration_date]
    promotion_definition_id = params[:promotion_definition_id]
    CouponGeneratorWorker.perform_async(quantity, uses, expiration_date, promotion_definition_id)
    render json: { success: true }, status: :ok
  end

  def index
    @promo_definition = PromotionDefinition.find_by(id: params[:promotion_definition_id])
    if @promo_definition
      @promotions = @promo_definition.promotions
      render_record_collection(Promotion, @promotions, { parent: { id: @promo_definition.id, name: @promo_definition.name } })
    else
      render_not_found(PromotionDefinition)
    end
  end

  private

  def promotion_definition_params
    params.require(:promotion_definition).permit(:name, :discount_type, :value, :promotion_state,
                                                 :promotion_type, :promotion_attributes, :conditions)
  end
end
