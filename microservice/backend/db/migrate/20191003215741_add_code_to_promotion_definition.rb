class AddCodeToPromotionDefinition < ActiveRecord::Migration[6.0]
  def change
    add_column :promotion_definitions, :code, :string
  end
end
