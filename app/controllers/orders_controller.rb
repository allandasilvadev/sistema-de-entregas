class OrdersController < ApplicationController
	def index
		@carrier = Carrier.find( params[:carrier_id] )
		@orders = Order.where( carrier_id: params[:carrier_id] )
	end

	def all
		@orders = Order.all
	end

	def show
		@order = Order.find( params[:id] )
	end

	def new
		@order = Order.new
		@carriers = Carrier.all
	end

	def create
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
		@carriers = Carrier.all
		@order = Order.find( params[:id] )


		if @order.status != 'pendente'
			flash[:notice] = 'Ordens aceitas pelas transportadoras não podem ser editadas.'
			redirect_to order_get_path( @order.id )
		end
	end

	def update
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
		@order = Order.find( params[:id] )
	end

	def destroy
		@order = Order.find(params[:id])
    @order.destroy    
    @orders = Order.all
    flash[:notice] = 'Ordem de serviço excluída com sucesso.'  
    redirect_to orders_all_path
  end

  def accept
  	@vehicles = Vehicle.where( params[:carrier_id] )
  	@order = Order.find( params[:id] )
  end

  def accept_update
  	@carriers = Carrier.all
		@carrier = Carrier.find(params[:order][:carrier_id])
		# strong parameters
		order_params = params.require(:order).permit(:status, :vehicle_id, :carrier_id)		
		@order = Order.find(params[:id])		
		if @order.carrier.id == Vehicle.find( params[:order][:vehicle_id] ).carrier_id && @order.update( order_params )
		# if @order.update(order_params)
			flash[:notice] = 'Ordem de serviço aceita com sucesso.'
			redirect_to order_path( @order.id )
		else
			flash.now[:notice] = 'Não foi possível aceitar essa ordem de serviço.'
			render 'edit'
		end
  end

end