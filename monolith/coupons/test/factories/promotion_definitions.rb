FactoryBot.define do
  factory :promotion_definition do
    name { Faker::Lorem.word }
    discount_type { %w[percentage value].sample }
    promotion_type { %w[coupon discount].sample }
    value { 10 }
    code { Faker::Code.npi }
    promotion_attributes { 'attribute_one' }
    conditions { 'attribute_one > 100' }
    organization
  end
end
