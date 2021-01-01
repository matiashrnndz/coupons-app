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

class PromotionDefinition < ApplicationRecord
  acts_as_paranoid
  acts_as_tenant(:organization)
  before_save :set_default_promotion_attributes

  scope :by_state, ->(state) { where(promotion_state: state) }
  scope :by_type, ->(type) { where(promotion_type: type) }
  scope :by_name, ->(name) { where('name like ?', "%#{name}%") }
  scope :by_code, ->(code) { where('code like ?', "%#{code}%") }

  has_many :promotions, dependent: :destroy
  belongs_to :organization

  validates :name, presence: true
  validates :name, uniqueness: { scope: :organization }
  validates :promotion_state, presence: true
  validates :discount_type, presence: true
  validates :promotion_type, presence: true
  validates :code, presence: true
  validates :code, uniqueness: true
  validate :correct_value
  validate :correct_conditions

  def correct_value
    errors.add(:value, ':invalid_value') unless value_is_valid?
  end

  def value_is_valid?
    !value.nil? && ((discount_type == 'percentage' && value >= 0 && value <= 100) ||
    (discount_type == 'value' && value >= 0))
  end

  def correct_conditions
    record_attrs = promotion_attributes.split(',')
    record_attrs << 'total'
    valid_conditions = LogicExpressionValidatorService.new.validate_logic_structure(record_attrs, conditions)
    errors.add(:conditions, 'Missing condition attributes or invalid condition') unless valid_conditions
  end

  # def value_is_valid?
  #   value.nil? || (discount_type == 'percentage' && value > 100) || value.negative?
  # end

  def set_default_promotion_attributes
    promotion_type_attributes unless persisted?
  end

  def promotion_type_attributes
    self.promotion_attributes = if promotion_type == 'coupon'
                                  "coupon_code, total, #{promotion_attributes}"
                                else
                                  "transaction_id, total, #{promotion_attributes}"
                                end
  end
end
