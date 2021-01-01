FactoryBot.define do
  factory :promotion do
    code { Faker::Code.npi }
    promotion_definition
  end
end
