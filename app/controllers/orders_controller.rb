class OrdersController < ApplicationController
	def index
		@carrier = Carrier.find( params[:carrier_id] )
		@orders = Order.where( carrier_id: params[:carrier_id] )
	end

	def show
		@order = Order.find( params[:id] )
	end
end