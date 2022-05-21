require 'rails_helper'

describe 'Usuário vê prazos' do
	it 'a partir da página de detalhes da transportadora' do
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
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Prazos'

		# Assert
		expect(current_path).to eq terms_path
	end

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
			minimum_distance: '0', # metros
			maximum_distance: '10_000', # metros
			days: '2', # dias
			carrier: acme
		)

		Term.create!(
			minimum_distance: '10_001', # metros
			maximum_distance: '40_000', # metros
			days: '5', # dias
			carrier: acme
		)

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Prazos'

		# Assert
		expect(current_path).to eq terms_path
		expect(page).to have_content 'Transportadora: ACME'
		expect(page).to have_content 'Tabela de prazos'
		expect(page).to have_content '0km a 10km'
		expect(page).to have_content '2 dias úteis'
		expect(page).to have_content '10.001km a 40km'
		expect(page).to have_content '5 dias úteis'
	end

	it 'e não vê prazos de outras transportadoras' do
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

		star = Carrier.create!(
			corporate_name: 'Star LTDA',
			brand_name: 'Star',
			registration_number: '12242556123254',
			full_address: 'Av. das Palmas, 4000',
			city: 'Salvador',
			state: 'BA',
			email_domain: 'star.com',
			activated: true
		)

		Term.create!(
			minimum_distance: '0', # metros
			maximum_distance: '10_000', # metros
			days: '2', # dias
			carrier: acme
		)

		Term.create!(
			minimum_distance: '0', # metros
			maximum_distance: '10_000', # metros
			days: '5', # dias
			carrier: star
		)

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'Star'
		click_on 'Prazos'

		# Assert
		expect(current_path).to eq terms_path
		expect(page).to have_content 'Transportadora: Star'
		expect(page).to have_content 'Tabela de prazos'
		expect(page).to have_content '0km a 10km'
		expect(page).to have_content '5 dias úteis'
		
		expect(page).not_to have_content 'Transportadora: ACME'
		expect(page).not_to have_content '2 dias úteis'
	end

	it 'e não existem prazos cadastrados' do
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
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Prazos'

		expect(current_path).to eq terms_path
		expect(page).to have_content 'Transportadora: ACME'
		expect(page).to have_content 'Tabela de prazos'
		expect(page).to have_content 'Não existem prazos cadastrados para esta transportadora.'
	end

	it 'e volta para página de detalhes da transportadora' do
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
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Prazos'
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq carrier_path(acme.id)
	end
end