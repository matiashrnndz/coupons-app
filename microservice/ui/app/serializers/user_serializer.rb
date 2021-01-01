class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :first_name, :last_name, :email, :created_at

  attribute :organization do |object, params|
    UserOrganizationSerializer.new(object.organization).serializable_hash[:data][:attributes]
  end
end