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

class Organization < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
  has_many :promotion_definitions, dependent: :restrict_with_error
  belongs_to :admin, foreign_key: :admin_id, class_name: 'User', optional: true, inverse_of: :organization

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :admin, presence: true
end
