class AddExpirationDateToPromotionDefinition < ActiveRecord::Migration[6.0]
  def change
    add_column :promotion_definitions, :expiration_date, :date
  end
end
