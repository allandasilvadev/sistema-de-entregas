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
end