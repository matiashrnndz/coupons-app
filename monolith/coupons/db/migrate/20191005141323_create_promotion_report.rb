class CreatePromotionReport < ActiveRecord::Migration[6.0]
  def change
    create_table :promotion_reports do |t|
      t.bigint :promotion_definition_id
      t.boolean :successful
      t.bigint :response_time
      t.bigint :spent_amount
      
      t.timestamps
    end
  end
end
