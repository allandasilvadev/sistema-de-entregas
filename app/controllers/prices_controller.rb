class PricesController < ApplicationController
	def index
		@carrier = Carrier.find( params[:carrier_id] )
		@prices = Price.where( carrier_id: params[:carrier_id] )
	end
end