class AddRoleAndCarrierIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role, :string, :default => 'carrier'
    add_reference :users, :carrier, null: true, foreign_key: true
  end
end
