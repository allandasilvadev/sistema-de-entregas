require 'rails_helper'

describe 'Usuário cadastra um novo veículo para uma transportadora' do
	it 'a partir da tela de detalhes de uma transportadora' do
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
		click_on 'Cadastrar novo veículo'

		# Assert
		expect(page).to have_field('Modelo')
		expect(page).to have_field('Fabricante')
		expect(page).to have_field('Ano')
		expect(page).to have_field('Placa')
		expect(page).to have_field('Identificador')
		expect(page).to have_field('Capacidade máxima')
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
		click_on 'Cadastrar novo veículo'
		fill_in 'Modelo', with: 'C-1731 Tractor'
		fill_in 'Fabricante', with: 'Ford'
		fill_in 'Ano', with: '2022'
		fill_in 'Placa', with: 'ABC4456'
		fill_in 'Identificador', with: 'SKU1245638'
		fill_in 'Capacidade máxima', with: '1000'
		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Veículo cadastrado com sucesso.'
		expect(page).to have_content 'Transportadora: ACME'
		expect(page).to have_content 'Modelo: C-1731 Tractor'
		expect(page).to have_content 'Placa: ABC4456'
		expect(page).to have_content 'Identificador: SKU1245638'
		expect(page).to have_content 'Capacidade máxima: 1000'
	end

	it 'com dados incompletos' do
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
		click_on 'Cadastrar novo veículo'
		fill_in 'Modelo', with: ''
		fill_in 'Placa', with: ''
		fill_in 'Identificador', with: ''
		fill_in 'Capacidade máxima', with: ''
		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Veículo não cadastrado.'
		expect(page).to have_content 'Modelo não pode ficar em branco'
		expect(page).to have_content 'Placa não pode ficar em branco'
		expect(page).to have_content 'Identificador não pode ficar em branco'
		expect(page).to have_content 'Capacidade máxima não pode ficar em branco'
	end

	it 'ou volta para a página de detalhes da transportadora' do
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
		click_on 'Cadastrar novo veículo'
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq carrier_path( acme.id )
	end
end