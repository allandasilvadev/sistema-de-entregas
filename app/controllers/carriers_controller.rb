class CarriersController < ApplicationController
	def index
		@carriers = Carrier.all
	end

	def show
		@carrier = Carrier.find(params[:id])
	end

	def new
		@carrier = Carrier.new
	end

	def create
		# strong parameters
		carrier_params = params.require(:carrier).permit(:corporate_name, :brand_name, :registration_number, :full_address, :city, :state, :email_domain, :activated)
		@carrier = Carrier.new(carrier_params)
		if @carrier.save()
			flash[:notice] = 'Transportadora cadastrada com sucesso.'
			redirect_to carrier_path( @carrier.id )
		else
			flash.now[:notice] = 'Transportadora não cadastrada.'
			render 'new'
		end
	end

	def edit
		@carrier = Carrier.find(params[:id])
	end

	def update
		# strong parameters
		carrier_params = params.require(:carrier).permit(:corporate_name, :brand_name, :registration_number, :full_address, :city, :state, :email_domain, :activated)
		@carrier = Carrier.find(params[:id])
		if @carrier.update(carrier_params)
			flash[:notice] = 'Transportadora atualizada com sucesso.'
			redirect_to carrier_path( @carrier.id )
		else
			flash.now[:notice] = 'Não foi possível atualizar a transportadora.'
			render 'edit'
		end
	end
end