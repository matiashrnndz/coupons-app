class PromotionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :code, :used, :created_at, :updated_at
end