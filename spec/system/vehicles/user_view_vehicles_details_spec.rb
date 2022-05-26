require 'rails_helper'

describe 'Usuário vê detalhes de um veículo' do
	it 'e vê informações adicionais' do
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

		Vehicle.create!(
			plate: 'ABC4456',
			identification: 'SKU1245638',
			brand: 'Ford',
			mockup: 'C-1731 Tractor',
			year: '2022',
			capacity: '1000',
			carrier: acme
		)

		user = User.create!(
			name: 'Maria',
			email: 'maria@email.com',
			password: '123456',
			role: 'carrier',
			carrier_id: acme.id
		)

		# Act
		login_as(user)
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Veículos'
		click_on 'C-1731 Tractor'

		# Assert
		expect(page).to have_content 'Transportadora: ACME'
		expect(page).to have_content 'Modelo: C-1731 Tractor'
		expect(page).to have_content 'Fabricante: Ford'
		expect(page).to have_content 'Ano: 2022'
		expect(page).to have_content 'Placa: ABC4456'
		expect(page).to have_content 'Identificador: SKU1245638'
		expect(page).to have_content 'Capacidade máxima: 1000'
	end

	it 'e volta para tela onde são listados os veículos' do
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

		Vehicle.create!(
			plate: 'ABC4456',
			identification: 'SKU1245638',
			brand: 'Ford',
			mockup: 'C-1731 Tractor',
			year: '2022',
			capacity: '1000',
			carrier: acme
		)

		user = User.create!(
			name: 'Maria',
			email: 'maria@email.com',
			password: '123456',
			role: 'carrier',
			carrier_id: acme.id
		)

		# Act
		login_as(user)
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Veículos'
		click_on 'C-1731 Tractor'
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq vehicles_path
	end
end