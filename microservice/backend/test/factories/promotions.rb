# == Schema Information
#
# Table name: promotions
#
#  id                      :bigint           not null, primary key
#  promotion_definition_id :bigint
#  code                    :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  uses                    :integer
#  expiration_date         :date
#

FactoryBot.define do
  factory :promotion do
    code { Faker::Code.npi }
    uses { 5 }
    expiration_date { Date.today + 1.days }
    promotion_definition
  end
end
