require 'rails_helper'

describe 'Usuário vê transportadoras' do
	it 'a partir do menu' do
		# Arrange

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end

		# Assert
		# expect(current_path).to eq carriers_path
		expect( current_path ).to eq new_user_session_path
	end

	# testa a listagem das transportadoras
	it 'com sucesso' do
		# Arrange
		# Somente administradores poderao ver TODAS as transportadoras cadastradas.
		user = User.create!(
			name: 'João da Silva',
			email: 'joao@email.com',
			password: '123456',
			role: 'administrator'
		)

		Carrier.create!(
			corporate_name: 'ACME LTDA',
			brand_name: 'ACME',
			registration_number: '12242556123245',
			full_address: 'Av. das Nações, 1000',
			city: 'Bauru',
			state: 'SP',
			email_domain: 'acme.com.br',
			activated: true
		)

		Carrier.create!(
			corporate_name: 'Star LTDA',
			brand_name: 'Star',
			registration_number: '12242556123222',
			full_address: 'Av. das Palmas, 4000',
			city: 'Salvador',
			state: 'BA',
			email_domain: 'star.com',
			activated: true
		)

		# Act
		login_as(user)
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end

		# Assert
		expect(page).to have_content('Transportadoras')
		expect(page).to have_content 'ACME'
		expect(page).to have_content 'Bauru - SP'
		expect(page).to have_content 'Star'
		expect(page).to have_content 'Salvador - BA'
	end

	it 'e não é o administrator' do
		# Arrange
		# Somente administradores poderao ver TODAS as transportadoras cadastradas.
		# Os outros usuário só poderão ver sua transportadora.
		Carrier.create!(
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
			registration_number: '12242556123222',
			full_address: 'Av. das Palmas, 4000',
			city: 'Salvador',
			state: 'BA',
			email_domain: 'star.com',
			activated: true
		)

		user = User.create!(
			name: 'João da Silva',
			email: 'joao@email.com',
			password: '123456',
			role: 'carrier',
			carrier_id: star.id
		)		

		# Act
		login_as(user)
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end

		# Assert
		expect(page).to have_content('Transportadoras')
		expect(page).to have_content 'Star'
		expect(page).to have_content 'Salvador - BA'
		# expect(current_path).to eq root_path
		# expect(page).to have_content 'Você não tem permissão para ver essa página.'
	end

	it 'e não existem transportadoras cadastradas' do
		# Arrange
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

		# Assert
		expect(page).to have_content 'Não existem transportadoras cadastradas.'
	end

	it 'e volta para tela inicial' do
		# Arrange
		user = User.create!(
			name: 'João da Silva',
			email: 'joao@email.com',
			password: '123456',
			role: 'administrator'
		)

		# Act
		login_as(user)
		visit carriers_path
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq root_path
	end
end