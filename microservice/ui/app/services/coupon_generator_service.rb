class CouponGeneratorService
  def self.generate(counter, promotion_definition_id)
    promotion_definition = PromotionDefinition.find_by(id: promotion_definition_id)
    if promotion_definition
      counter.times do
        code = CodeGeneratorService.generate(8)
        Promotion.create(code: code, promotion_definition: promotion_definition)
      end
    end
  end
end
