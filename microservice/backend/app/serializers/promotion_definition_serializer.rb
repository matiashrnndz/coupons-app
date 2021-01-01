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

class PromotionDefinitionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :code, :name, :discount_type, :value, :promotion_state, :promotion_type, :promotion_attributes, :conditions, :expiration_date, :created_at
end
