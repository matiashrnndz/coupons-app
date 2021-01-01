FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }
    admin { FactoryBot.build(:user) }
  end
end
