class PricesController < ApplicationController
	before_action :authenticate_user!, only: [:index, :new, :create, :edit, :update, :destroy]

	def index
		if current_user.role != 'administrator'
			@carrier = Carrier.find( current_user.carrier_id )
			@prices = Price.where( carrier_id: @carrier.id )
		else
			@carrier = Carrier.find( params[:carrier_id] )
			@prices = Price.where( carrier_id: params[:carrier_id] )
		end		
	end

	def new
		if current_user.role != 'administrator'
			@carrier = Carrier.find(current_user.carrier_id)
		else
			@carrier = Carrier.find(params[:carrier_id])
		end	

		@price = Price.new
	end

	def create
		if current_user.role != 'administrator'
			@carrier = Carrier.find( current_user.carrier_id )
		else
			@carrier = Carrier.find(params[:price][:carrier_id])
		end

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

	def edit
		if current_user.role != 'administrator'
			@price = Price.find(params[:id])
			if @price.carrier_id != current_user.carrier_id
				redirect_to prices_path
			end
		else
			@price = Price.find(params[:id])
		end		
	end

	def update
		# strong parameters
		price_params = params.require(:price).permit(:cubic_meter_min, :cubic_meter_max, :minimum_weight, :maximum_weight, :km_price, :carrier_id)		
		
		if current_user.role != 'administrator'
			@price = Price.find(params[:id])
			if @price.carrier_id != current_user.carrier_id
				redirect_to prices_path
			end
		else
			@price = Price.find(params[:id])
		end		

		if @price.update(price_params)
			flash[:notice] = 'Faixa de preço atualizada com sucesso.'
			redirect_to prices_path( carrier_id: params[:price][:carrier_id] )
		else
			flash.now[:notice] = 'Não foi possível atualizar a faixa de preço.'
			render 'edit'
		end
	end

	def destroy
		if current_user.role != 'administrator'
			@price = Price.find(params[:id])
			if @price.carrier_id != current_user.carrier_id
				redirect_to prices_path
			end
		else
			@price = Price.find(params[:id])
		end				
    @price.destroy    
    @prices = Price.where( carrier_id: params[:carrier_id] )
    flash[:notice] = 'Faixa de preço excluída com sucesso.'  
    redirect_to prices_path( carrier_id: params[:carrier_id] )
  end
end