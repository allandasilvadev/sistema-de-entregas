class CreateCarriers < ActiveRecord::Migration[7.0]
  def change
    create_table :carriers do |t|
      t.string :corporate_name
      t.string :brand_name
      t.string :registration_number
      t.string :full_address
      t.string :city
      t.string :state
      t.string :email_domain
      t.boolean :activated

      t.timestamps
    end
  end
end
