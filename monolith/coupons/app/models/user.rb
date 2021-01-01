# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  first_name      :string
#  last_name       :string
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint
#

class User < ApplicationRecord
  acts_as_tenant(:organization)

  belongs_to :organization
  has_secure_password
  has_one_attached :avatar

  validates :first_name, presence: true, format: /\A[a-zA-Z]+\z/, length: { maximum: 20 }
  validates :last_name, presence: true, format: /\A[a-zA-Z]+\z/, length: { maximum: 20 }
  validates :email, presence: true, format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6, allow_blank: true }
end
