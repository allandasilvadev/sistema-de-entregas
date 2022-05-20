class Vehicle < ApplicationRecord
  belongs_to :carrier
  validates :mockup, :plate, :identification, :capacity, presence: true
  validates :plate, length: { is: 7 }
  validates :plate, uniqueness: true
end
