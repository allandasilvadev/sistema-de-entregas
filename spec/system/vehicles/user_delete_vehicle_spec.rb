require 'rails_helper'

describe 'Usuário remove um veículo' do
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
		click_on 'Remover'

		# Assert
		# expect(current_path).to eq vehicles_path
		expect(page).to have_content 'Veículo removido com sucesso.'
		expect(page).not_to have_content 'Modelo: C-1731 Tractor'
		expect(page).not_to have_content 'Placa: ABC4456'
	end

	it 'e não apaga outros veículos' do
		# Arrange
		# Criar duas transportadoras e cadastrar um veiculo para cada uma delas.
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

		Vehicle.create!(
			plate: 'ABC5644',
			identification: 'SKU2424567',
			brand: 'Ford',
			mockup: 'C-1244 Tractor',
			year: '2021',
			capacity: '2000',
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
		click_on 'Remover'

		# Assert
		# expect(current_path).to eq vehicles_path
		expect(page).to have_content 'Veículo removido com sucesso.'
		expect(page).not_to have_content 'Modelo: C-1731 Tractor'
		expect(page).not_to have_content 'Placa: ABC4456'
		expect(page).to have_content 'Modelo: C-1244 Tractor'
		expect(page).to have_content 'Placa: ABC5644'
	end
end