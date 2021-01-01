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

class Promotion < ApplicationRecord
  belongs_to :promotion_definition

  validates :code, presence: true
  validates :code, uniqueness: { scope: :promotion_definition }
  validates :uses, numericality: { greater_than_or_equal_to: 0,  only_integer: true }

  validate :correct_expiration_date

  def correct_expiration_date
    errors.add(:expiration_date, 'Expiration date cannot be greater than promotion definition') unless valid_expiration_date
  end

  def valid_expiration_date
    promotion_definition && expiration_date <= promotion_definition.expiration_date
  end
end
