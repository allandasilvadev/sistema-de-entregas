class CreateVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicles do |t|
      t.string :plate
      t.string :identification
      t.string :brand
      t.string :mockup
      t.integer :year
      t.string :capacity
      t.references :carrier, null: false, foreign_key: true

      t.timestamps
    end
  end
end
