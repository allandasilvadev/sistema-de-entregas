class CreatePrices < ActiveRecord::Migration[7.0]
  def change
    create_table :prices do |t|
      t.integer :cubic_meter_min
      t.integer :cubic_meter_max
      t.integer :minimum_weight
      t.integer :maximum_weight
      t.integer :km_price
      t.references :carrier, null: false, foreign_key: true

      t.timestamps
    end
  end
end
