class VehiclesController < ApplicationController
	def index
		@vehicles = Vehicle.where( carrier_id: params[:carrier_id] )
	end

	def show
		@vehicle = Vehicle.find(params[:id])
	end

	def new
		@carrier = Carrier.find(params[:carrier_id])
		@vehicle = Vehicle.new
	end

	def create
		@carrier = Carrier.find(params[:vehicle][:carrier_id])
		# strong parameters
		vehicle_params = params.require(:vehicle).permit(:mockup, :brand, :year, :plate, :identification, :capacity, :carrier_id)		
		@vehicle = Vehicle.new(vehicle_params)
		if @vehicle.save()
			flash[:notice] = 'Veículo cadastrado com sucesso.'
			redirect_to vehicle_path( @vehicle.id )
		else
			flash.now[:notice] = 'Veículo não cadastrado.'
			render 'new', locals: {  carrier: @carrier }
		end
	end
end