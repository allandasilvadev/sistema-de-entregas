class Order < ApplicationRecord
  belongs_to :carrier
  belongs_to :vehicle, optional: true
  validates :collection_address, :sku_product, :height, :width, :depth, :weight, :delivery_address, :recipient_name, :recipient_cpf, :status, :code, :distance, :location, presence: true
  validates :code, uniqueness: true
  validates :height, :width, :depth, :weight, :distance, :numericality => { :greater_than => 0 }
end
