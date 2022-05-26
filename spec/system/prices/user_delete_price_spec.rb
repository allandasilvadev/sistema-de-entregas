require 'rails_helper'

describe 'Usuário remove uma faixa de preço' do
	it 'com sucesso' do
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

		Price.create!(
			cubic_meter_min: 1, # cm3
			cubic_meter_max: 50, # cm3
			minimum_weight: 0,   # g
			maximum_weight: 10_000, # g
			km_price: 50, # centavos
			carrier: acme
		)

		user = User.create(
			name: 'Maria',
			email: 'maria@email.com',
			password: '1235678',
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
		click_on 'Consultar preços'
		click_on 'Remover'

		# Assert
		expect(current_path).to eq prices_path
		expect(page).to have_content('Faixa de preço excluída com sucesso.')
		expect(page).not_to have_content '0.01cm3 a 0.05cm3'
		expect(page).not_to have_content '0kg a 10kg'
		expect(page).not_to have_content 'R$ 0.50'
	end

	it 'e não apaga outras faixas de preço' do
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

		one = Price.create!(
			cubic_meter_min: 1, # cm3
			cubic_meter_max: 50, # cm3
			minimum_weight: 0,   # g
			maximum_weight: 10_000, # g
			km_price: 50, # centavos
			carrier: acme
		)

		Price.create!(
			cubic_meter_min: 1, # cm3
			cubic_meter_max: 50, # cm3
			minimum_weight: 12_500,   # g
			maximum_weight: 30_000, # g
			km_price: 80, # centavos
			carrier: acme
		)

		user = User.create(
			name: 'Maria',
			email: 'maria@email.com',
			password: '1235678',
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
		click_on 'Consultar preços'
		within("td#price-#{one.id}") do
			click_on 'Remover'
		end

		# Assert
		expect(current_path).to eq prices_path
		expect(page).to have_content('Faixa de preço excluída com sucesso.')
		
		expect(page).not_to have_content '0.01cm3 a 0.05cm3'
		expect(page).not_to have_content '0kg a 10kg'
		expect(page).not_to have_content 'R$ 0.50'

		expect(page).to have_content '0.01cm3 a 0.5cm3'
		expect(page).to have_content '12.5kg a 30kg'		
		expect(page).to have_content 'R$ 0.80'
	end
end