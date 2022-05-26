require 'rails_helper'

describe 'Usuário cadastra uma transportadora' do
	it 'a partir da tela de listagem das transportadoras' do
		# Arrange
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
			click_on 'Transportadoras'
		end
		click_on 'Cadastrar Transportadora'

		# Assert
		# verifica se todos os campos necessarios existem.
		expect(page).to have_field('Razão social')
		expect(page).to have_field('Nome fantasia')
		expect(page).to have_field('CNPJ')
		expect(page).to have_field('Endereço')
		expect(page).to have_field('Cidade')
		expect(page).to have_field('Estado')
		expect(page).to have_field('Domínio')
		expect(page).to have_field('Status')
	end

	it 'a partir da tela de listagem das transportadoras, e não é um administrator' do
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
		click_on 'Cadastrar Transportadora'

		# Assert
		# verifica se todos os campos necessarios existem.
		expect(current_path).to eq root_path
		expect(page).to have_content 'Somente administradores podem cadastrar novas transportadoras.'
	end

	it 'com sucesso' do
		# Arrange
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
			click_on 'Transportadoras'
		end
		click_on 'Cadastrar Transportadora'
		fill_in 'Razão social', with: 'ACME LTDA'
		fill_in 'Nome fantasia', with: 'ACME'
		fill_in 'CNPJ', with: '12242556123254'
		fill_in 'Endereço', with: 'Rua das Flores, 200'
		fill_in 'Cidade', with: 'Bauru'
		fill_in 'Estado', with: 'SP'
		fill_in 'Domínio', with: 'acme.com.br'
		select 'Activated', from: 'Status'
		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Transportadora cadastrada com sucesso.'
		expect(page).to have_content 'ACME LTDA'
		expect(page).to have_content '12242556123254'
		expect(page).to have_content 'acme.com.br'
	end

	it 'com dados imcompletos' do
		# Arrange
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
			click_on 'Transportadoras'
		end
		click_on 'Cadastrar Transportadora'
		fill_in 'Razão social', with: ''
		fill_in 'CNPJ', with: ''
		fill_in 'Domínio', with: ''
		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Transportadora não cadastrada.'
		expect(page).to have_content 'Razão social não pode ficar em branco'
		expect(page).to have_content 'CNPJ não pode ficar em branco'
	end

	it 'ou volta para listagem de transportadoras' do
		# Arrange
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
			click_on 'Transportadoras'
		end
		click_on 'Cadastrar Transportadora'
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq carriers_path
	end
end