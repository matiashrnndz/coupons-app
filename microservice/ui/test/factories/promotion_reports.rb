FactoryBot.define do
  factory :promotion_report do
    successful { true }
    response_time { 1000 }
    spent_amount { 200 }
    promotion_definition
  end
end
