class CreatePromotion < ActiveRecord::Migration[6.0]
  def change
    create_table :promotions do |t|
      t.bigint :promotion_definition_id
      t.string :code
      t.boolean :used, default: false
      
      t.timestamps
    end
  end
end
