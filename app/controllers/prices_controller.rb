class PricesController < ApplicationController
	def index
		@carrier = Carrier.find( params[:carrier_id] )
		@prices = Price.where( carrier_id: params[:carrier_id] )
	end

	def new
		@carrier = Carrier.find(params[:carrier_id])
		@price = Price.new
	end

	def create
		@carrier = Carrier.find(params[:price][:carrier_id])
		# strong parameters
		price_params = params.require(:price).permit(:cubic_meter_min, :cubic_meter_max, :minimum_weight, :maximum_weight, :km_price, :carrier_id)		
		@price = Price.new(price_params)
		if @price.save()
			flash[:notice] = 'Faixa de preço cadastrada com sucesso.'
			redirect_to prices_path( carrier_id: @price.carrier.id )
		else
			flash.now[:notice] = 'Faixa de preço não cadastrada.'
			render 'new', locals: {  carrier: @carrier }
		end
	end
end