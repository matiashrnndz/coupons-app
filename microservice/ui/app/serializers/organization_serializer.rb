class OrganizationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :created_at
  attribute :users do |object, params|
    OrganizationUserSerializer.new(object.users).serializable_hash[:data].map do |user|
      user[:attributes]
    end
  end
end