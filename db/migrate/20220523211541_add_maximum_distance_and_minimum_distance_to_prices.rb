class AddMaximumDistanceAndMinimumDistanceToPrices < ActiveRecord::Migration[7.0]
  def change
    add_column :prices, :minimum_distance, :integer
    add_column :prices, :maximum_distance, :integer
  end
end
