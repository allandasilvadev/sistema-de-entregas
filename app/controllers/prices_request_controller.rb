class PricesRequestController < ApplicationController
	def index
		res = params[:height].to_f * params[:width].to_f * params[:depth].to_f
		res = res / 1_000_000

		if params[:search]
			if !params[:height].empty? and !params[:width].empty? and !params[:depth].empty? and !params[:distance].empty? and !params[:weight].empty?
				@prices = Price.where( "minimum_distance >= ? and maximum_distance >= ? and cubic_meter_min >= ? and cubic_meter_max >= ? and minimum_weight <= ? and maximum_weight >= ?", params[:distance], params[:distance], res, res, params[:weight], params[:weight] )
				@dados = @prices
				@distance = params[:distance].to_f / 1000
				render 'index'
			else
				@dados = []
				flash.now[:notice] = 'Você deve preencher todos os campos para fazer a consulta.'
				render 'index'
			end
		else
			@dados = []
			render 'index'
		end		
		
	end
end