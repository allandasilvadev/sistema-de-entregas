class Price < ApplicationRecord
  belongs_to :carrier
  validates :cubic_meter_min, :cubic_meter_max, :minimum_weight, :maximum_weight, :km_price, presence: true
  validates :cubic_meter_min, :cubic_meter_max, :minimum_weight, :maximum_weight, :numericality => { :greater_than_or_equal_to => 0 }
  validates :km_price, :numericality => { :greater_than_or_equal_to => 50 }
end
