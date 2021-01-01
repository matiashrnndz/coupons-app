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
#  role            :string           default("normal")
#

class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :first_name, :last_name, :email, :role, :created_at

  attribute :organization do |object, params|
    UserOrganizationSerializer.new(object.organization).serializable_hash[:data][:attributes]
  end
end
