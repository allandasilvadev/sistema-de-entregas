class VehiclesController < ApplicationController
	before_action :authenticate_user!, only: [:index, :show, :new, :create, :edit, :update, :destroy]

	def index
		if current_user.role != 'administrator'
			@vehicles = Vehicle.where( carrier_id: current_user.carrier_id )
		else
			@vehicles = Vehicle.where( carrier_id: params[:carrier_id] )
		end		
	end

	def show
		if current_user.role != 'administrator'
			@vehicle = Vehicle.find(params[:id])
			if @vehicle.carrier_id != current_user.carrier_id
				redirect_to vehicles_path
			end
		else
			@vehicle = Vehicle.find(params[:id])
		end
		
	end

	def new
		if current_user.role != 'administrator'
			@carrier = Carrier.find(current_user.carrier_id)
		else
			@carrier = Carrier.find(params[:carrier_id])			
		end
		@vehicle = Vehicle.new		
	end

	def create
		if current_user.role != 'administrator'
			@carrier = Carrier.find(current_user.carrier_id)
		else
			@carrier = Carrier.find(params[:vehicle][:carrier_id])
		end
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

	def edit
		if current_user.role != 'administrator'
			@vehicle = Vehicle.find(params[:id])
			if @vehicle.carrier_id != current_user.carrier_id
				redirect_to vehicles_path
			end
		else
			@vehicle = Vehicle.find(params[:id])
		end			
	end

	def update
		# strong parameters
		vehicle_params = params.require(:vehicle).permit(:mockup, :brand, :year, :plate, :identification, :capacity, :carrier_id)		
		
		if current_user.role != 'administrator'
			@vehicle = Vehicle.find(params[:id])
			if @vehicle.carrier_id != current_user.carrier_id
				redirect_to vehicles_path
			end
		else
			@vehicle = Vehicle.find(params[:id])
		end			

		if @vehicle.update(vehicle_params)
			flash[:notice] = 'Veículo atualizado com sucesso.'
			redirect_to vehicle_path( @vehicle.id )
		else
			flash.now[:notice] = 'Não foi possível atualizar o veículo.'
			render 'edit'
		end
	end

	def destroy
		if current_user.role != 'administrator'
			@vehicle = Vehicle.find(params[:id])
			if @vehicle.carrier_id != current_user.carrier_id
				redirect_to vehicles_path
			end
		else
			@vehicle = Vehicle.find(params[:id])
		end			

    @vehicle.destroy    
    @vehicles = Vehicle.where( carrier_id: params[:carrier_id] )
    flash[:notice] = 'Veículo removido com sucesso.'  
    render 'index'
  end
end