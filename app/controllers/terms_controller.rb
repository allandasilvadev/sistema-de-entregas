class TermsController < ApplicationController
	def index
		@carrier = Carrier.find( params[:carrier_id] )
		@terms = Term.where( carrier_id: params[:carrier_id] )
	end

	def new
		@carrier = Carrier.find(params[:carrier_id])
		@term = Term.new
	end

	def create
		@carrier = Carrier.find(params[:term][:carrier_id])
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
end