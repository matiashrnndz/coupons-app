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

class PromotionReport < ApplicationRecord
  scope :for_promotion, ->(promotion_definition) { where(promotion_definition: promotion_definition) }
  scope :positive, -> { where(successful: true) }

  belongs_to :promotion_definition

  validates :response_time, presence: true
  validates :spent_amount, presence: true
end
