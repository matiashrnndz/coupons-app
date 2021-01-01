class CouponGeneratorWorker
  include Sidekiq::Worker

  def perform(quantity, uses, expiration_date, promotion_definition_id)
    CouponGeneratorService.generate(quantity, uses, expiration_date, promotion_definition_id)
  end
end
