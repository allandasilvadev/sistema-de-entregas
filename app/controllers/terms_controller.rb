class TermsController < ApplicationController
	def index
		@carrier = Carrier.find( params[:carrier_id] )
		@terms = Term.where( carrier_id: params[:carrier_id] )
	end
end