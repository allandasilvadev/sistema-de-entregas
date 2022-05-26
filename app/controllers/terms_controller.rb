class TermsController < ApplicationController
	before_action :authenticate_user!, only: [:index, :new, :create, :edit, :update, :destroy]

	def index
		if current_user.role != 'administrator'
			@carrier = Carrier.find( current_user.carrier_id )
			@terms = Term.where( carrier_id: @carrier.id )
		else
			@carrier = Carrier.find( params[:carrier_id] )
			@terms = Term.where( carrier_id: params[:carrier_id] )
		end		
	end

	def new
		if current_user.role != 'administrator'
			@carrier = Carrier.find( current_user.carrier_id )
		else
			@carrier = Carrier.find(params[:carrier_id])
		end
		
		@term = Term.new
	end

	def create
		if current_user.role != 'administrator'
			@carrier = Carrier.find( current_user.carrier_id )
		else
			@carrier = Carrier.find(params[:term][:carrier_id])
		end
		
		# strong parameters
		term_params = params.require(:term).permit(:minimum_distance, :maximum_distance, :days, :carrier_id)		
		@term = Term.new(term_params)
		if @term.save()
			flash[:notice] = 'Prazo cadastrado com sucesso.'
			redirect_to terms_path( carrier_id: @term.carrier.id )
		else
			flash.now[:notice] = 'Prazo não cadastrado.'
			render 'new', locals: {  carrier: @carrier }
		end
	end

	def edit
		if current_user.role != 'administrator'
			@term = Term.find(params[:id])
			if @term.carrier_id != current_user.carrier_id
				redirect_to terms_path
			end
		else
			@term = Term.find(params[:id])
		end				
	end

	def update
		# strong parameters
		term_params = params.require(:term).permit(:minimum_distance, :maximum_distance, :days, :carrier_id)		
		# @term = Term.find(params[:id])

		if current_user.role != 'administrator'
			@term = Term.find(params[:id])
			if @term.carrier_id != current_user.carrier_id
				redirect_to terms_path
			end
		else
			@term = Term.find(params[:id])
		end		

		if @term.update(term_params)
			flash[:notice] = 'Prazo atualizado com sucesso.'
			redirect_to terms_path( carrier_id: params[:term][:carrier_id] )
		else
			flash.now[:notice] = 'Não foi possível atualizar o prazo.'
			render 'edit'
		end
	end

	def destroy
		if current_user.role != 'administrator'
			@term = Term.find(params[:id])
			if @term.carrier_id != current_user.carrier_id
				redirect_to terms_path
			end
		else
			@term = Term.find(params[:id])
		end		
		
		# @term = Term.find(params[:id])
    @term.destroy    
    @terms = Term.where( carrier_id: params[:carrier_id] )
    flash[:notice] = 'Prazo excluído com sucesso.'  
    redirect_to terms_path( carrier_id: params[:carrier_id] )
  end
end