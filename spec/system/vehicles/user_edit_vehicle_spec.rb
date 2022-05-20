require 'rails_helper'

describe 'Usuário edita veículo' do
	it 'a partir da página de veículos' do
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

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Veículos'
		click_on 'C-1731 Tractor'
		click_on 'Editar'

		# Assert
		expect(page).to have_content('Transportadora: ACME')
		expect(page).to have_content('Editar veículo')
		expect(page).to have_field('Modelo', with: 'C-1731 Tractor')
		expect(page).to have_field('Fabricante', with: 'Ford')
		expect(page).to have_field('Ano', with: '2022')
		expect(page).to have_field('Placa', with: 'ABC4456')
		expect(page).to have_field('Identificador', with: 'SKU1245638')
		expect(page).to have_field('Capacidade máxima', with: '1000')
	end

	it 'com sucesso' do
		# Arrange
		acme = Carrier.create!(
			corporate_name: 'ACME LTDA',
			brand_name: 'ACME',
			registration_number: '12242556123254',
			full_address: 'Av. das Nações, 1000',
			city: 'São Paulo',
			state: 'SP',
			email_domain: 'acme.com.br',
			activated: true
		)

		tractor = Vehicle.create!(
			plate: 'ABC4456',
			identification: 'SKU1245638',
			brand: 'Ford',
			mockup: 'C-1731 Tractor',
			year: '2022',
			capacity: '1000',
			carrier: acme
		)

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Veículos'
		click_on 'C-1731 Tractor'
		click_on 'Editar'
		fill_in 'Placa', with: 'ABC4458'
		fill_in 'Capacidade máxima', with: '2000'
		click_on 'Enviar'

		# Assert
		expect(current_path).to eq vehicle_path( tractor.id )
		expect(page).to have_content 'Veículo atualizado com sucesso.'
		expect(page).to have_content 'Placa: ABC4458'
		expect(page).to have_content 'Capacidade máxima: 2000'
	end

	it 'e mantém os campos obrigatórios' do
		# Arrange
		acme = Carrier.create!(
			corporate_name: 'ACME LTDA',
			brand_name: 'ACME',
			registration_number: '12242556123254',
			full_address: 'Av. das Nações, 1000',
			city: 'São Paulo',
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

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Veículos'
		click_on 'C-1731 Tractor'
		click_on 'Editar'
		fill_in 'Modelo', with: ''
		fill_in 'Placa', with: ''
		fill_in 'Identificador', with: ''
		fill_in 'Capacidade máxima', with: ''
		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Não foi possível atualizar o veículo.'
	end

	it 'ou volta para listagem de veículos' do
		# Arrange
		acme = Carrier.create!(
			corporate_name: 'ACME LTDA',
			brand_name: 'ACME',
			registration_number: '12242556123254',
			full_address: 'Av. das Nações, 1000',
			city: 'São Paulo',
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

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Veículos'
		click_on 'C-1731 Tractor'
		click_on 'Editar'
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq vehicles_path
	end
end