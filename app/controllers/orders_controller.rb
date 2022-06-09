class OrdersController < ApplicationController
	before_action :authenticate_user!, only: [:index, :all, :show, :new, :create, :edit, :update, :getOne, :destroy, :accept, 
		:accept_update, :update_status, :upd_status]
	
	def index
		@carrier = Carrier.find( current_user.carrier_id )
		@orders = Order.where( carrier_id: current_user.carrier_id )
	end

	def all
		if current_user.role != 'administrator'			
			flash[:notice] = 'Você não pode visualizar ordens de serviço de outras transportadoras.'
			redirect_to orders_path
		else
			@orders = Order.all
		end
		
	end

	def show
		@all_status = { "aceita" => "aceita", "pendente" => "pendente", "in_progress" => 'Em andamento', "finished" => 'Finalizada', "canceled" => 'Cancelada' }
		if current_user.role != 'administrator'
			@order = Order.find( params[:id] )
			if @order.carrier.id != current_user.carrier_id
				flash[:notice] = 'Você não pode visualizar ordens de serviço de outras transportadoras.'
				redirect_to orders_path
			end 
		else
			@order = Order.find( params[:id] )
		end
	end

	def new
		# somente administradores poderão cadastrar novas ordens de serviço.
		if current_user.role != 'administrator'
			redirect_to orders_path
  	end

		@order = Order.new
		@carriers = Carrier.all
	end

	def create
		# somente administradores poderão cadastrar novas ordens de serviço.
		if current_user.role != 'administrator'
			redirect_to orders_path
  	end

		@carriers = Carrier.all
		@carrier = Carrier.find(params[:order][:carrier_id])
		# strong parameters
		order_params = params.require(:order).permit(:collection_address, :sku_product, :height, :width, :depth, :weight, :delivery_address, :recipient_name, :recipient_cpf, :code, :distance, :carrier_id)		
		order_params[:status] = 'pendente'
		order_params[:location] = order_params[:collection_address]

		@order = Order.new(order_params)
		if @order.save()
			flash[:notice] = 'Ordem de serviço criada com sucesso.'
			redirect_to order_path( @order.id )
		else
			flash.now[:notice] = 'Não foi possível criar a ordem de serviço.'
			render 'new', locals: {  carrier: @carrier }
		end
	end

	def edit
		# somente administradores poderão editar ordens de serviço.
		# usuarios de transportadora só poderão editar a localização e o status
		if current_user.role != 'administrator'
			redirect_to orders_path
  	end

		@carriers = Carrier.all
		@order = Order.find( params[:id] )


		if @order.status != 'pendente'
			flash[:notice] = 'Ordens aceitas pelas transportadoras não podem ser editadas.'
			redirect_to order_get_path( @order.id )
		end
	end

	def update
		# somente administradores poderão editar ordens de serviço.
		# usuarios de transportadora só poderão editar a localização e o status
		if current_user.role != 'administrator'
			redirect_to orders_path
  	end
  	
		@carriers = Carrier.all
		@carrier = Carrier.find(params[:order][:carrier_id])
		# strong parameters
		order_params = params.require(:order).permit(:distance, :delivery_address, :recipient_name, :recipient_cpf, :carrier_id)		
		@order = Order.find(params[:id])
		if @order.update(order_params)
			flash[:notice] = 'Ordem de serviço atualizada com sucesso.'
			redirect_to order_get_path( @order.id )
		else
			flash.now[:notice] = 'Não foi possivel atualizar a ordem de serviço.'
			render 'edit'
		end
	end

	def getOne
		if current_user.role != 'administrator'
			redirect_to orders_path
		else
			@order = Order.find( params[:id] )
		end
			
	end

	def destroy
		# somente administradores poderão excluir ordens de serviço
		if current_user.role != 'administrator'
			redirect_to orders_path
  	end

		@order = Order.find(params[:id])
    @order.destroy    
    @orders = Order.all
    flash[:notice] = 'Ordem de serviço excluída com sucesso.'  
    redirect_to all_orders_path
  end

  def accept
  	if current_user.role != 'administrator'
  		@order = Order.find( params[:id] )
  		
  		if @order.carrier.id != current_user.carrier_id
				redirect_to orders_path
			end 
  	end

  	@vehicles = Vehicle.where( params[:carrier_id] )
  	@order = Order.find( params[:id] )
  end

  def accept_update
  	if current_user.role != 'administrator'
  		@order = Order.find( params[:id] )
  		
  		if @order.carrier.id != current_user.carrier_id
				redirect_to orders_path
			end 
  	end

  	@carriers = Carrier.all
		@carrier = Carrier.find(params[:order][:carrier_id])
		# strong parameters
		order_params = params.require(:order).permit(:status, :vehicle_id, :carrier_id)		
		@order = Order.find(params[:id])		
		if @order.carrier.id == Vehicle.find( params[:order][:vehicle_id] ).carrier_id && @order.update( order_params )
			flash[:notice] = 'Ordem de serviço aceita com sucesso.'
			redirect_to order_path( @order.id )
		else
			flash.now[:notice] = 'Não foi possível aceitar essa ordem de serviço.'
			render 'edit'
		end
  end


  def update_status
  	@all_status = { "aceita" => "aceita", "in_progress" => 'Em andamento', "finished" => 'Finalizada', "canceled" => 'Cancelada' }

  	if current_user.role != 'administrator'
  		@order = Order.find( params[:id] )
  		
  		if @order.carrier.id != current_user.carrier_id
				redirect_to orders_path
			end 
  	else
  		@order = Order.find( params[:id] )
  	end
  end

  def upd_status
  	@all_status = { "aceita" => "aceita", "pendente" => "pendente", "in_progress" => 'Em andamento', "finished" => 'Finalizada', "canceled" => 'Cancelada' }

  	if current_user.role != 'administrator'
  		@order = Order.find( params[:id] )
  		
  		if @order.carrier.id != current_user.carrier_id
				redirect_to orders_path
			end 
  	end

  	@carriers = Carrier.all
		@carrier = Carrier.find(params[:order][:carrier_id])
		# strong parameters
		order_params = params.require(:order).permit(:status, :location, :date_and_time, :carrier_id)		
		@order = Order.find(params[:id])		
		if @order.update( order_params )
			flash[:notice] = 'A localização e o status da ordem de serviço foram atualizadas com sucesso.'
			redirect_to order_path( @order.id )
		else
			flash.now[:notice] = 'Não foi possível atualizar o status da ordem de serviço.'
			render 'update_status'
		end
  end

  # não é necessário autenticacao
  def open
  	@all_status = { "aceita" => "aceita", "pendente" => "pendente", "in_progress" => 'Em andamento', "finished" => 'Finalizada', "canceled" => 'Cancelada' }
  	if params[:code]
  		@order = Order.where(code: params[:code]).first
  		if @order.nil?
  			@dados = []
  			flash[:notice] = 'O código informado está incorreto.'
  			render 'open'
  		else
  			@dados = { 
	  			"code" => @order.code, 
	  			"location" => @order.location, 
	  			"delivery_address" => @order.delivery_address,
	  			"recipient_name" => @order.recipient_name,
	  			"recipient_cpf" => @order.recipient_cpf,
	  			"status" => @order.status,
	  			"date_and_time" => @order.date_and_time 
	  		}
  		end  		
  	else
  		@dados = []
  		render 'open'
  	end
  end

end