class PromotionDefinitionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :code, :name, :discount_type, :value, :promotion_state, :promotion_type, :promotion_attributes, :conditions, :created_at
end