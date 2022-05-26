class CreateInquiries < ActiveRecord::Migration[7.0]
  def change
    create_table :inquiries do |t|
      t.string :carrier
      t.string :cubic_meter_min
      t.string :cubic_meter_max
      t.string :minimum_weight
      t.string :maximum_weight
      t.string :km_price
      t.string :delivery_price
      t.string :request_date

      t.timestamps
    end
  end
end
