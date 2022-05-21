class Order < ApplicationRecord
  belongs_to :carrier
  belongs_to :vehicle, optional: true
end
