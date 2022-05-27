class PricesRequestController < ApplicationController
	before_action :authenticate_user!, only: [:index, :create, :all]

	def index
		if current_user.role != 'administrator'
			flash[:notice] = 'Somente administradores podem fazer consultas de preços.'
			return redirect_to root_path
		end 

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

	def create
		if current_user.role != 'administrator'
			flash[:notice] = 'Somente administradores podem fazer consultas de preços.'
			return redirect_to root_path
		end 

		# strong parameters
		inquiry_params = params.permit(:carrier,:cubic_meter_min, :cubic_meter_max, :minimum_weight, :maximum_weight, :km_price, :delivery_price, :request_date)		
		@inquiry = Inquiry.new(inquiry_params)
		if @inquiry.save()
			flash[:notice] = 'Consulta de preço salva com sucesso.'
			redirect_to prices_request_index_path
		else
			flash.now[:notice] = 'A consulta de preço não pode ser salva.'
			redirect_to prices_request_index_path
		end
	end

	def all
		if current_user.role != 'administrator'
			flash[:notice] = 'Você não pode visualizar consultas de preços feitas pelo administrator.'
			return redirect_to root_path
		end

		@inquiries = Inquiry.all
	end
end