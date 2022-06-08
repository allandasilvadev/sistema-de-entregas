require 'rails_helper'

describe 'Usuário se autentica' do
	it 'com sucesso' do
		# Arrange
		User.create!(name: 'João da Silva', email: 'joao@email.com', password: '123456')

		# Act
		visit root_path
		within('div.user-credentials') do
			click_on 'Entrar'
		end
		within('form') do
			fill_in 'E-mail', with: 'joao@email.com'
			fill_in 'Senha', with: '123456'
			click_on 'Entrar'
		end

		# Assert
		expect(page).to have_content 'Login efetuado com sucesso.'
		expect(page).not_to have_link 'Entrar'
		expect(page).to have_button 'Sair'
		within('div.user-credentials') do
			expect(page).to have_content 'joao@email.com'
		end
	end

	it 'e é um usuário do tipo transportadora' do
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
			name: 'Marcos', 
			email: 'marcos@acme.com', 
			password: '123456', 
			role: 'carrier', 
			carrier_id: acme.id
		)
		# Act
		visit root_path
		within('div.user-credentials') do
			click_on 'Entrar'
		end
		within('form') do
			fill_in 'E-mail', with: 'marcos@acme.com'
			fill_in 'Senha', with: '123456'
			click_on 'Entrar'
		end
		# Assert
		expect(page).to have_content 'Login efetuado com sucesso.'
		expect(page).not_to have_link 'Entrar'
		expect(page).to have_button 'Sair'
		within('div.user-credentials') do
			expect(page).to have_content 'marcos@acme.com'
		end

		expect(page).to have_link 'Transportadoras'
		expect(page).not_to have_link 'Cadastrar nova ordem de serviço'
		expect(page).not_to have_link 'Consultar preços'
	end

	it 'e faz logout' do
		# Arrange
		User.create!(name: 'João da Silva', email: 'joao@email.com', password: '123456')

		# Act
		visit root_path
		within('div.user-credentials') do
			click_on 'Entrar'
		end
		within('form') do
			fill_in 'E-mail', with: 'joao@email.com'
			fill_in 'Senha', with: '123456'
			click_on 'Entrar'
		end
		within('div.user-credentials') do
			click_on 'Sair'
		end

		# Assert
		expect(page).to have_content 'Logout efetuado com sucesso.'
		expect(page).to have_link 'Entrar'
		expect(page).not_to have_button 'Sair'
		expect(page).not_to have_content 'joao@email.com'
	end
end