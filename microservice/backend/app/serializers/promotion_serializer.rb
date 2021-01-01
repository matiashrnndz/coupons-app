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

class PromotionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :code, :uses, :created_at, :expiration_date, :updated_at
end
