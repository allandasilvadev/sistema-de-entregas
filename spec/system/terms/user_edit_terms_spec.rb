require 'rails_helper'

describe 'Usuário edita prazo' do
	it 'a partir da página com a tabela de prazos' do
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

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Prazos'
		click_on 'Editar'

		# Assert
		expect(page).to have_content 'Transportadora: ACME'
		expect(page).to have_content 'Editar prazo'
		expect(page).to have_field('Distância miníma em metros', with: '0')
		expect(page).to have_field('Distância máxima em metros', with: '10000')
		expect(page).to have_field('Dias úteis', with: '2')
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
			minimum_distance: '0',
			maximum_distance: '10_000',
			days: '2',
			carrier: acme
		)

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Prazos'
		click_on 'Editar'
		fill_in 'Distância miníma em metros', with: '10_000'
		fill_in 'Distância máxima em metros', with: '40_000'
		fill_in 'Dias úteis', with: '4'
		click_on 'Enviar'

		# Assert
		expect(current_path).to eq terms_path
		expect(page).to have_content 'Tabela de prazos'
		expect(page).to have_content 'Prazo atualizado com sucesso.'
		expect(page).to have_content '10km a 40km'
		expect(page).to have_content '4 dias úteis'
	end

	it 'e mantém campos obrigatórios' do
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

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Prazos'
		click_on 'Editar'
		fill_in 'Distância miníma em metros', with: ''
		fill_in 'Distância máxima em metros', with: ''
		fill_in 'Dias úteis', with: ''
		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Transportadora: ACME'
		expect(page).to have_content 'Editar prazo'
		expect(page).to have_content 'Não foi possível atualizar o prazo.'
		expect(page).to have_content 'Distância miníma em metros não pode ficar em branco'
		expect(page).to have_content 'Distância máxima em metros não pode ficar em branco'
		expect(page).to have_content 'Dias úteis não pode ficar em branco'
	end

	it 'e mantém os campos válidos' do
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

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Prazos'
		click_on 'Editar'
		fill_in 'Distância miníma em metros', with: '-8'
		fill_in 'Distância máxima em metros', with: '0'
		fill_in 'Dias úteis', with: '0'
		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Transportadora: ACME'
		expect(page).to have_content 'Editar prazo'
		expect(page).to have_content 'Não foi possível atualizar o prazo.'
		expect(page).to have_content 'Distância miníma em metros deve ser maior ou igual a 0'
		expect(page).to have_content 'Distância máxima em metros deve ser maior que 0'
		expect(page).to have_content 'Dias úteis deve ser maior que 0'
	end

	it 'ou volta para listagem de prazos' do
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

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Prazos'
		click_on 'Editar'
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq terms_path
	end
end