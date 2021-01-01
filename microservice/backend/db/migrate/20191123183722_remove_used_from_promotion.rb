class RemoveUsedFromPromotion < ActiveRecord::Migration[6.0]
  def change
    remove_column :promotions, :used
  end
end
