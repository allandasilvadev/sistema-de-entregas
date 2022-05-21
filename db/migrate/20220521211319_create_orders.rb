class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :collection_address
      t.string :sku_product
      t.string :height
      t.string :width
      t.string :depth
      t.string :weight
      t.string :delivery_address
      t.string :recipient_name
      t.string :recipient_cpf
      t.string :status
      t.string :code
      t.references :carrier, null: false, foreign_key: true
      t.references :vehicle, null: true, foreign_key: true

      t.timestamps
    end
  end
end
