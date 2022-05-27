require 'rails_helper'

describe 'Usuário edita transportadora' do
	it 'a partir da página de detalhes' do
		# Arrange
		Carrier.create!(
			corporate_name: 'ACME LTDA',
			brand_name: 'ACME',
			registration_number: '12242556123254',
			full_address: 'Av. das Nações, 1000',
			city: 'São Paulo',
			state: 'SP',
			email_domain: 'acme.com.br',
			activated: true
		)

		user = User.create!(
			name: 'João da Silva',
			email: 'joao@email.com',
			password: '123456',
			role: 'administrator'
		)

		# Act
		login_as(user)
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Editar'

		# Assert
		expect(page).to have_content 'Editar Transportadora'

		expect(page).to have_field('Razão social', with: 'ACME LTDA')
		expect(page).to have_field('Nome fantasia', with: 'ACME')
		expect(page).to have_field('CNPJ', with: '12242556123254')
		expect(page).to have_field('Endereço', with: 'Av. das Nações, 1000')
		expect(page).to have_field('Cidade', with: 'São Paulo')
		expect(page).to have_field('Estado', with: 'SP')
		expect(page).to have_field('Domínio', with: 'acme.com.br')
		expect(page).to have_field('Status', with: 'true')
	end

	it 'a partir da página de detalhes, e não é um administrator' do
		# Arrange
		star = Carrier.create!(
			corporate_name: 'Star LTDA',
			brand_name: 'Star',
			registration_number: '12242556123288',
			full_address: 'Av. das Palmas, 1000',
			city: 'Salvador',
			state: 'BA',
			email_domain: 'star',
			activated: true
		)

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

		user = User.create!(
			name: 'João da Silva',
			email: 'joao@email.com',
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
		visit edit_carrier_path( star.id )

		# Assert
		expect(page).to have_content 'Você não pode editar as informações de outras transportadoras.'

		expect(page).to have_field('Razão social', with: 'ACME LTDA')
		expect(page).to have_field('Nome fantasia', with: 'ACME')
		expect(page).to have_field('CNPJ', with: '12242556123254')
		expect(page).to have_field('Endereço', with: 'Av. das Nações, 1000')
		expect(page).to have_field('Cidade', with: 'São Paulo')
		expect(page).to have_field('Estado', with: 'SP')
		expect(page).to have_field('Domínio', with: 'acme.com.br')
		expect(page).to have_field('Status', with: 'true')
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
		click_on 'ACME'
		click_on 'Editar'
		fill_in 'Endereço', with: 'Rua das Flores, 244'
		fill_in 'Cidade', with: 'Bauru'
		click_on 'Enviar'

		# Assert
		expect(current_path).to eq carrier_path( acme.id )
		expect(page).to have_content 'Transportadora atualizada com sucesso.'
		expect(page).to have_content 'Endereço: Rua das Flores, 244 - Bauru - SP'
	end

	it 'e mantém os campos obrigatórios' do
		# Arrange
		Carrier.create!(
			corporate_name: 'ACME LTDA',
			brand_name: 'ACME',
			registration_number: '12242556123254',
			full_address: 'Av. das Nações, 1000',
			city: 'São Paulo',
			state: 'SP',
			email_domain: 'acme.com.br',
			activated: true
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
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Editar'
		fill_in 'Razão social', with: ''
		fill_in 'CNPJ', with: ''
		fill_in 'Domínio', with: ''
		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Não foi possível atualizar a transportadora.'
	end

	it 'ou volta para listagem de transportadoras' do
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
		click_on 'Editar'
		click_on 'Voltar'
		
		# Assert
		expect(current_path).to eq carriers_path
	end
end