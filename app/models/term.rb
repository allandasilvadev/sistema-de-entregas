class Term < ApplicationRecord
  belongs_to :carrier
  validates :minimum_distance, :maximum_distance, :days, presence: true
  validates :minimum_distance, :numericality => { :greater_than_or_equal_to => 0 }
  validates :days, :maximum_distance, :numericality => { :greater_than => 0 }
end
