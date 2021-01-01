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

class OrganizationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :created_at
  attribute :users do |object, params|
    OrganizationUserSerializer.new(object.users).serializable_hash[:data].map do |user|
      user[:attributes]
    end
  end
end
