class Vehicle < ApplicationRecord
  belongs_to :carrier
  belongs_to :order, optional: true
  validates :mockup, :plate, :identification, :capacity, presence: true
  validates :plate, length: { is: 7 }
  validates :plate, :identification, uniqueness: true
end
