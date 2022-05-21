require 'rails_helper'

describe 'Usuário cadastra um novo prazo' do
	it 'a partir da página de detalhes da transportadora' do
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
		click_on 'Cadastrar novo prazo'

		# Assert
		expect(page).to have_field('Distância miníma em metros')
		expect(page).to have_field('Distância máxima em metros')
		expect(page).to have_field('Dias úteis')
	end

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

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Cadastrar novo prazo'
		fill_in 'Distância miníma em metros', with: '10_000'
		fill_in 'Distância máxima em metros', with: '40_000'
		fill_in 'Dias úteis', with: '6'
		click_on 'Enviar'

		# Assert
		expect(current_path).to eq terms_path
		expect(page).to have_content 'Prazo cadastrado com sucesso.'
		expect(page).to have_content 'Transportadora: ACME'
		expect(page).to have_content '10km a 40km'
		expect(page).to have_content '6 dias úteis'
	end

	it 'com dados imcompletos' do
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
		click_on 'Cadastrar novo prazo'
		fill_in 'Distância miníma em metros', with: ''
		fill_in 'Distância máxima em metros', with: ''
		fill_in 'Dias úteis', with: ''
		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Prazo não cadastrado.'
		expect(page).to have_content 'Transportadora: ACME'
		expect(page).to have_content 'Distância miníma em metros não pode ficar em branco'
		expect(page).to have_content 'Distância máxima em metros não pode ficar em branco'
		expect(page).to have_content 'Dias úteis não pode ficar em branco'
	end

	it 'com dados inválidos' do
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
		click_on 'Cadastrar novo prazo'
		fill_in 'Distância miníma em metros', with: '-1'
		fill_in 'Distância máxima em metros', with: '-20'
		fill_in 'Dias úteis', with: '0'
		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Prazo não cadastrado.'
		expect(page).to have_content 'Transportadora: ACME'
		expect(page).to have_content 'Distância miníma em metros deve ser maior ou igual a 0'
		expect(page).to have_content 'Distância máxima em metros deve ser maior que 0'
		expect(page).to have_content 'Dias úteis deve ser maior que 0'
	end

	it 'e volta para listagem de prazos' do
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
		click_on 'Cadastrar novo prazo'
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq terms_path
	end
end