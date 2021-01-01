# == Schema Information
#
# Table name: promotions
#
#  id                      :bigint           not null, primary key
#  promotion_definition_id :bigint
#  code                    :string
#  used                    :boolean          default(FALSE)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class Promotion < ApplicationRecord
  belongs_to :promotion_definition

  validates :code, presence: true
  validates :code, uniqueness: true
end
