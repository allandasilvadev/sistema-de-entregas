require 'rails_helper'

describe 'Usuário remove um prazo' do
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

		Term.create!(
			minimum_distance: '0',
			maximum_distance: '10_000',
			days: '2',
			carrier: acme
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
		click_on 'Prazos'
		click_on 'Remover'

		# Assert
		expect(current_path).to eq terms_path
		expect(page).to have_content 'Prazo excluído com sucesso.'
		expect(page).not_to have_content '0km a 10km'
		expect(page).not_to have_content '2 dias úteis'
	end

	it 'e não apaga outros prazos' do
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

		one = Term.create!(
			minimum_distance: '0',
			maximum_distance: '10_000',
			days: '2',
			carrier: acme
		)

		Term.create!(
			minimum_distance: '10_001',
			maximum_distance: '40_000',
			days: '4',
			carrier: acme
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
		click_on 'Prazos'
		within("td#prazo-#{one.id}") do
			click_on 'Remover'
		end

		# Assert
		expect(current_path).to eq terms_path
		expect(page).to have_content 'Prazo excluído com sucesso.'
		expect(page).not_to have_content '0km a 10km'
		expect(page).not_to have_content '2 dias úteis'

		expect(page).to have_content '10.001km a 40km'
		expect(page).to have_content '4 dias úteis'
	end
end