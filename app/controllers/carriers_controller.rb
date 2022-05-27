class CarriersController < ApplicationController
	# add authentication
	before_action :authenticate_user!, only: [:index, :show, :new, :create, :edit, :update, :disable, :disable_post]

	def index
		if current_user.role != 'administrator'
			@carriers = Carrier.where( id: current_user.carrier_id )
			if @carriers.empty?
				redirect_to root_path, notice: 'Você não tem permissão para ver essa página.'
			end
		else
			@carriers = Carrier.all
		end
	end

	def show
		if current_user.role != 'administrator'
			@carrier = Carrier.find( current_user.carrier_id )
			if params[:id] != @carrier.id
					flash[:notice] = 'Você não pode visualizar as informações de outras transportadoras.'								
			end
		else
			@carrier = Carrier.find(params[:id])
		end		
	end

	def new
		if current_user.role != 'administrator'
			flash[:notice] = 'Somente administradores podem cadastrar novas transportadoras.'
			redirect_to root_path
		else
			@carrier = Carrier.new
		end		
	end

	def create
		if current_user.role != 'administrator'
			flash[:notice] = 'Somente administradores podem cadastrar novas transportadoras.'
			redirect_to root_path
		else
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

	def edit
		if current_user.role != 'administrator'
			@carrier = Carrier.find( current_user.carrier_id )
			if params[:id] != @carrier.id
				flash[:notice] = 'Você não pode editar as informações de outras transportadoras.'				
			end
		else
			@carrier = Carrier.find(params[:id])
		end		
	end

	def update
		# strong parameters
		carrier_params = params.require(:carrier).permit(:corporate_name, :brand_name, :registration_number, :full_address, :city, :state, :email_domain, :activated)

		if current_user.role != 'administrator'
			@carrier = Carrier.find( current_user.carrier_id )
			if params[:id] != @carrier.id
				flash[:notice] = 'Você não pode editar as informações de outras transportadoras.'				
			end
		else
			@carrier = Carrier.find(params[:id])
		end		

		if @carrier.update(carrier_params)
			flash[:notice] = 'Transportadora atualizada com sucesso.'
			redirect_to carrier_path( @carrier.id )
		else
			flash.now[:notice] = 'Não foi possível atualizar a transportadora.'
			render 'edit'
		end

	end

	def disable
		if current_user.role != 'administrator'
			@carrier = Carrier.find( current_user.carrier_id )
			if params[:id] != @carrier.id
				flash[:notice] = 'Você não pode ativar ou desativar outras transportadoras.'
			end
		else
			@carrier = Carrier.find(params[:id])
		end		
	end

	def disable_post
		# strong parameters
		carrier_params = params.require(:carrier).permit(:activated)
		@carrier = Carrier.find( params[:carrier_id] )
		if @carrier.update(carrier_params)
			flash[:notice] = 'O status da transportadora foi alterado com sucesso.'
			redirect_to carrier_path( @carrier.id )
		else
			flash.now[:notice] = 'Não foi possível alterar o status da transportadora.'
			render 'disable'
		end
	end
end