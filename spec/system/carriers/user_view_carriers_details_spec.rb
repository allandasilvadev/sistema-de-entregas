require 'rails_helper'

describe 'Usuário vê detalhes de uma transportadora' do
	it 'e vê informações adicionais' do
		# Arrange
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

		# Assert
		expect(page).to have_content 'Razão social: ACME LTDA'
		expect(page).to have_content 'Nome fantasia: ACME'
		expect(page).to have_content 'CNPJ: 12242556123245'
		expect(page).to have_content 'Endereço: Av. das Nações, 1000 - Bauru - SP'
		expect(page).to have_content 'Domínio: acme.com.br'
		expect(page).to have_content 'Status: activated'
	end

	it 'que não é sua' do
		# Arrange
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
			carrier_id: star.id
		)


		# Act
		login_as(user)
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		# click_on 'ACME'
		visit carrier_path( acme.id )

		# Assert
		expect(page).to have_content 'Você não pode visualizar as informações de outras transportadoras.'
		expect(page).not_to have_content 'Razão social: ACME LTDA'
		expect(page).not_to have_content 'Nome fantasia: ACME'
		expect(page).not_to have_content 'CNPJ: 12242556123245'
		expect(page).not_to have_content 'Endereço: Av. das Nações, 1000 - Bauru - SP'
		expect(page).not_to have_content 'Domínio: acme.com.br'

		expect(page).to have_content 'Razão social: Star LTDA'
		expect(page).to have_content 'Nome fantasia: Star'
		expect(page).to have_content 'CNPJ: 12242556123222'
		expect(page).to have_content 'Endereço: Av. das Palmas, 4000 - Salvador - BA'
		expect(page).to have_content 'Domínio: star.com'
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

		user = User.create!(
			name: 'Luiza',
			email: 'luiza@email.com',
			password: '123546',
			role: 'carrier',
			carrier_id: acme.id
		)

		# Act
		login_as(user)
		visit carrier_path( acme.id )
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq carriers_path
	end
end