class AddOrganizationIdToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :organization_id, :bigint
  end
end
