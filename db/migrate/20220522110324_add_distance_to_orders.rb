class AddDistanceToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :distance, :integer
  end
end
