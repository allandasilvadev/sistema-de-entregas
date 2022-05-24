require 'rails_helper'

describe 'Usuário se cadastra' do
	it 'com sucesso' do
		# Arrange

		# Act
		visit root_path
		within('nav') do
			click_on 'Entrar'
		end
		click_on 'Criar conta'
		within('form') do
			fill_in 'Nome', with: 'Maria'
			fill_in 'E-mail', with: 'maria@email.com'
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