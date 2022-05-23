class AddDateAndTimeToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :date_and_time, :string
  end
end
