require 'rails_helper'

describe 'Usuário vê consultas de preços, salvas no banco de dados' do
	it 'a partir da página, consultar preços' do
		# Arrange
		user = User.create(
			name: 'João',
			email: 'joao@email.com',
			password: '123456',
			role: 'administrator'
		)

		# Act
		login_as(user)
		visit root_path
		within('nav') do
			click_on 'Consultar preços'
		end
		click_on 'Visualizar consultas de preços anteriores'

		# Assert
		expect(current_path).to eq prices_request_all_path
		expect(page).to have_content 'Consultas de preços anteriores'
	end

	it 'e não é um administrador' do
		# Arrange
		acme = Carrier.create!(
			corporate_name: 'ACME LTDA',
			brand_name: 'ACME',
			registration_number: '12242556123245',
			full_address: 'Av. das Nações, 1000',
			city: 'Bauru',
			state: 'SP',
			email_domain: 'acme.com.br',
			activated: true
		)

		user = User.create(
			name: 'João',
			email: 'joao@email.com',
			password: '123456',
			role: 'carrier',
			carrier_id: acme.id
		)

		# Act
		login_as(user)
		visit prices_request_all_path

		# Assert
		expect(current_path).to eq root_path
		expect(page).to have_content 'Você não pode visualizar consultas de preços feitas pelo administrator.'
	end

	it 'com sucesso' do
		# Arrange
		acme = Carrier.create!(
			corporate_name: 'ACME LTDA',
			brand_name: 'ACME',
			registration_number: '12242556123245',
			full_address: 'Av. das Nações, 1000',
			city: 'Bauru',
			state: 'SP',
			email_domain: 'acme.com.br',
			activated: true
		)

		Price.create!(
			cubic_meter_min: 1, # cm3
			cubic_meter_max: 50, # cm3
			minimum_weight: 0,   # g
			maximum_weight: 10_000, # g
			km_price: 50, # centavos
			carrier: acme,
			minimum_distance: 0,
			maximum_distance: 10_000
		)

		star = Carrier.create!(
			corporate_name: 'Star LTDA',
			brand_name: 'Star',
			registration_number: '12242556123254',
			full_address: 'Av. das Palmas, 1000',
			city: 'Salvador',
			state: 'BA',
			email_domain: 'star.com',
			activated: true
		)

		Price.create!(
			cubic_meter_min: 1, # cm3
			cubic_meter_max: 50, # cm3
			minimum_weight: 0,   # g
			maximum_weight: 10_000, # g
			km_price: 50, # centavos
			carrier: star,
			minimum_distance: 10_000,
			maximum_distance: 20_000
		)

		wayne = Carrier.create!(
			corporate_name: 'Wayne LTDA',
			brand_name: 'Wayne',
			registration_number: '12242556123222',
			full_address: 'Rua da Mangueiras, 4080',
			city: 'Limeira',
			state: 'SP',
			email_domain: 'wayne.com.br',
			activated: true
		)

		Price.create!(
			cubic_meter_min: 1, # cm3
			cubic_meter_max: 50, # cm3
			minimum_weight: 0,   # g
			maximum_weight: 10_000, # g
			km_price: 75, # centavos
			carrier: wayne,
			minimum_distance: 10_000,
			maximum_distance: 60_000
		)

		user = User.create!(
			name: 'Maria',
			email: 'maria@email.com',
			password: '123456',
			role: 'administrator'
		)

		# Act
		login_as(user)
		visit root_path
		within('nav') do
			click_on 'Consultar preços'
		end
		fill_in 'Altura em centímetros', with: '60'
		fill_in 'Largura em centímetros', with: '60'
		fill_in 'Profundidade em centímetros', with: '10'
		fill_in 'Peso em gramas', with: '8000'
		fill_in 'Distância em metros', with: '10000'
		click_on 'Enviar'

		within("div#save-#{star.id}") do
			click_on 'Salvar'
		end

		click_on 'Visualizar consultas de preços anteriores'		

		# Assert
		expect(current_path).to eq prices_request_all_path
		expect(page).to have_content 'Star' 
		expect(page).to have_content '0.01cm3' 
		expect(page).to have_content '0.5cm3'
		expect(page).to have_content '0kg'
		expect(page).to have_content '10kg'
		expect(page).to have_content 'R$ 0.50'
		expect(page).to have_content "#{Time.now.strftime('%d/%m/%Y %H:%M')}"
	end

	it 'e não existem consultas de preços cadastradas' do
		# Arrange
		user = User.create(
			name: 'João',
			email: 'joao@email.com',
			password: '123456',
			role: 'administrator'
		)

		# Act
		login_as(user)
		visit root_path
		within('nav') do
			click_on 'Consultar preços'
		end
		click_on 'Visualizar consultas de preços anteriores'

		# Assert
		expect(current_path).to eq prices_request_all_path
		expect(page).to have_content 'Não existem consultas de preços anteriores'
	end
end