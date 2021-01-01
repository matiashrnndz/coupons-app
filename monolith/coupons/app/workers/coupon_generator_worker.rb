class CouponGeneratorWorker
  include Sidekiq::Worker

  def perform(quantity, promotion_definition_id)
    CouponGeneratorService.generate(quantity, promotion_definition_id)
  end
end
