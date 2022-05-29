require 'rails_helper'

describe 'Usuário se cadastra' do
	it 'com sucesso' do
		# Arrange
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
		visit root_path
		within('div.user-credentials') do
			click_on 'Entrar'
		end
		click_on 'Criar conta'
		within('form') do
			fill_in 'Nome', with: 'Maria'
			fill_in 'E-mail', with: 'maria@email.com'
			select 'Transportadora', from: 'Nível'
			select 'ACME', from: 'Transportadora'
			fill_in 'Senha', with: '123456'
			fill_in 'Confirme sua senha', with: '123456'
			click_on 'Criar conta'
		end

		# Assert
		expect(page).to have_content 'Você realizou seu registro com sucesso.'
		expect(page).to have_content 'maria@email.com'
		expect(page).to have_button 'Sair'
		user = User.last
		expect(user.name).to eq 'Maria'
	end
end