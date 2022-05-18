class Carrier < ApplicationRecord
	validates :corporate_name, :registration_number, :email_domain, presence: true
	validates :registration_number, length: { is: 14 }
	validates :registration_number, uniqueness: true
end
