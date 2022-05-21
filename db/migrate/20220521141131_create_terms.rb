class CreateTerms < ActiveRecord::Migration[7.0]
  def change
    create_table :terms do |t|
      t.integer :minimum_distance
      t.integer :maximum_distance
      t.integer :days
      t.references :carrier, null: false, foreign_key: true

      t.timestamps
    end
  end
end
