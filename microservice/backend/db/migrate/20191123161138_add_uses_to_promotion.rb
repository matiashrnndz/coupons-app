class AddUsesToPromotion < ActiveRecord::Migration[6.0]
  def change
    add_column :promotions, :uses, :integer
  end
end
