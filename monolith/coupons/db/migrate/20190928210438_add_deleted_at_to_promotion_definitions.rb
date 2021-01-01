class AddDeletedAtToPromotionDefinitions < ActiveRecord::Migration[6.0]
  def change
    add_column :promotion_definitions, :deleted_at, :datetime
    add_index :promotion_definitions, :deleted_at
  end
end
