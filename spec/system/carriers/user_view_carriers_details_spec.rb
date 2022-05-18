require 'rails_helper'

describe 'Usuário vê detalhes de uma transportadora' do
	it 'e vê informações adicionais' do
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

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'

		# Assert
		expect(page).to have_content 'Razão social: ACME LTDA'
		expect(page).to have_content 'Nome fantasia: ACME'
		expect(page).to have_content 'CNPJ: 12242556123245'
		expect(page).to have_content 'Endereço: Av. das Nações, 1000 - Bauru - SP'
		expect(page).to have_content 'Domínio: acme.com.br'
		expect(page).to have_content 'Status: activated'
	end

	it 'e volta para tela onde são listadas as transportadoras' do
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

		# Act
		visit carrier_path( acme.id )
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq carriers_path
	end
end