# == Schema Information
#
# Table name: organizations
#
#  id         :bigint           not null, primary key
#  name       :string
#  admin_id   :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }
    admin { FactoryBot.build(:user) }
  end
end
