class AddExpirationDateToPromotion < ActiveRecord::Migration[6.0]
  def change
    add_column :promotions, :expiration_date, :date
  end
end
