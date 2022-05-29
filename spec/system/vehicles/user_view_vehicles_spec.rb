require 'rails_helper'

describe 'Usuário vê veículos' do
	it 'a partir do menu' do
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
			click_on 'Veículos'
		end

		# Assert
		expect(current_path).to eq vehicles_path
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
		within('p.carriers-vehicles') do
			click_on 'Veículos'
		end

		# Assert
		expect(current_path).to eq vehicles_path
		expect(page).to have_content 'Modelo: C-1731 Tractor'
		expect(page).to have_content 'Placa: ABC4456'	
		expect(page).to have_content 'Identificador: SKU1245638'	
		expect(page).to have_content 'Modelo: C-1244 Tractor'
		expect(page).to have_content 'Placa: ABC5644'
		expect(page).to have_content 'Identificador: SKU2424567'
	end

	it 'e não vê veiculos de outras transportadoras' do
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

		star = Carrier.create!(
			corporate_name: 'Star LTDA',
			brand_name: 'Star',
			registration_number: '12242556123277',
			full_address: 'Av. das Palmas, 8400',
			city: 'Salvador',
			state: 'BA',
			email_domain: 'star.com',
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
			carrier: star
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
		within('p.carriers-vehicles') do
			click_on 'Veículos'
		end

		# Assert
		expect(current_path).to eq vehicles_path
		expect(page).to have_content 'Modelo: C-1731 Tractor'
		expect(page).to have_content 'Placa: ABC4456'	
		expect(page).to have_content 'Identificador: SKU1245638'	
		expect(page).not_to have_content 'Modelo: C-1244 Tractor'
		expect(page).not_to have_content 'Placa: ABC5644'
		expect(page).not_to have_content 'Identificador: SKU2424567'
	end

	it 'e não existem veículos cadastrados' do
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
		within('p.carriers-vehicles') do
			click_on 'Veículos'
		end

		# Assert
		expect(current_path).to eq vehicles_path
		expect(page).to have_content 'Não existem veículos cadastrados.'
	end

	it 'e volta para tela inicial' do
		# Arrage
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

		user = User.create!(
			name: 'Maria',
			email: 'maria@email.com',
			password: '123456',
			role: 'carrier',
			carrier_id: acme.id
		)

		# Act
		login_as(user)
		visit vehicles_path
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq root_path
	end
end