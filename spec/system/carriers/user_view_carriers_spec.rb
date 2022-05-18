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
		expect(current_path).to eq carriers_path
	end

	# testa a listagem das transportadoras
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

	it 'e não existem transportadoras cadastradas' do
		# Arrange

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end

		# Assert
		expect(page).to have_content 'Não existem transportadoras cadastradas.'
	end

	it 'e volta para tela inicial' do
		# Arrange
		# Act
		visit carriers_path
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq root_path
	end
end