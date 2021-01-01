class UserOrganizationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :created_at
end