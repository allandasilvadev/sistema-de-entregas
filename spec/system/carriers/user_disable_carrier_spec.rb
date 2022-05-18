require 'rails_helper'

describe 'Usuário desativa transportadora' do
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

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Habilitar/Desabilitar'

		# Assert
		expect(page).to have_content 'Habilitar/Desabilitar Transportadora'
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

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Habilitar/Desabilitar'
		select 'Deactivated', from: 'Status'
		click_on 'Enviar'

		# Assert
		expect(current_path).to eq carrier_path( acme.id )
		expect(page).to have_content 'O status da transportadora foi alterado com sucesso.'
		expect(page).to have_content 'Status: deactivated'
	end

	it 'e não desativa outras transportadoras' do
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

		star = Carrier.create!(
			corporate_name: 'Star LTDA',
			brand_name: 'Star',
			registration_number: '12242556123222',
			full_address: 'Rua das Flores, 4000',
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
		click_on 'ACME'
		click_on 'Habilitar/Desabilitar'
		select 'Deactivated', from: 'Status'
		click_on 'Enviar'
		visit carrier_path( star.id )

		# Assert
		expect(page).to have_content 'Razão social: Star LTDA'
		expect(page).to have_content 'Endereço: Rua das Flores, 4000 - Salvador - BA'
		expect(page).to have_content 'Status: activated'

	end
end