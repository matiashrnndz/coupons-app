class CreatePromotionDefinition < ActiveRecord::Migration[6.0]
  def change
    create_table :promotion_definitions do |t|
      t.string :name
      t.string :discount_type
      t.bigint :value
      t.string :promotion_state, :default => 'active'
      t.string :promotion_type
      t.string :promotion_attributes
      t.string :conditions, default: 'true'
      t.bigint :organization_id
      
      t.timestamps
    end
  end
end
