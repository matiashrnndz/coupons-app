# == Schema Information
#
# Table name: promotion_definitions
#
#  id                   :bigint           not null, primary key
#  name                 :string
#  discount_type        :string
#  value                :bigint
#  promotion_state      :string           default("active")
#  promotion_type       :string
#  promotion_attributes :string
#  conditions           :string           default("true")
#  organization_id      :bigint
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  deleted_at           :datetime
#  code                 :string
#  expiration_date      :date
#

FactoryBot.define do
  factory :promotion_definition do
    name { Faker::Lorem.word }
    discount_type { %w[percentage value].sample }
    promotion_type { %w[coupon discount].sample }
    value { 10 }
    code { Faker::Code.npi }
    promotion_attributes { 'attribute_one' }
    conditions { 'attribute_one > 100' }
    expiration_date { Date.today + 1.days }
    organization
  end
end
