# == Schema Information
#
# Table name: promotion_reports
#
#  id                      :bigint           not null, primary key
#  promotion_definition_id :bigint
#  successful              :boolean
#  response_time           :bigint
#  spent_amount            :bigint
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

FactoryBot.define do
  factory :promotion_report do
    successful { true }
    response_time { 1000 }
    spent_amount { 200 }
    promotion_definition
  end
end
