require 'rails_helper'

describe 'Usuário cadastra uma nova faixa de preço para uma transportadora' do
	it 'a partir da tela de detalhes da transportadora' do
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
		click_on 'Cadastrar nova faixa de preço'

		# Assert
		expect(current_path).to eq new_price_path
		expect(page).to have_content 'Cadastrar nova faixa de preço'
		expect(page).to have_field('Tamanho minímo em centímetros cúbicos')
		expect(page).to have_field('Tamanho máximo em centímetros cúbicos')
		expect(page).to have_field('Peso minímo em gramas')
		expect(page).to have_field('Peso máximo em gramas')
		expect(page).to have_field('Preço por quilômetro em centavos')
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
		click_on 'Cadastrar nova faixa de preço'
		fill_in 'Tamanho minímo em centímetros cúbicos', with: '1'
		fill_in 'Tamanho máximo em centímetros cúbicos', with: '50'
		fill_in 'Peso minímo em gramas', with: '0'
		fill_in 'Peso máximo em gramas', with: '10_000'
		fill_in 'Preço por quilômetro em centavos', with: '50'
		click_on 'Enviar'

		# Assert
		expect(current_path).to eq prices_path
		expect(page).to have_content 'Faixa de preço cadastrada com sucesso.'
		expect(page).to have_content 'Transportadora: ACME'
		expect(page).to have_content 'Tabela de preços'
		expect(page).to have_content '0.01cm3 a 0.5cm3'
		expect(page).to have_content '0kg a 10kg'
		expect(page).to have_content 'R$ 0.50'
	end

	it 'com dados imcompletos' do
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
		click_on 'Cadastrar nova faixa de preço'
		fill_in 'Tamanho minímo em centímetros cúbicos', with: ''
		fill_in 'Tamanho máximo em centímetros cúbicos', with: ''
		fill_in 'Peso minímo em gramas', with: ''
		fill_in 'Peso máximo em gramas', with: ''
		fill_in 'Preço por quilômetro em centavos', with: ''
		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Faixa de preço não cadastrada.'
		expect(page).to have_content 'Tamanho minímo em centímetros cúbicos não pode ficar em branco'
		expect(page).to have_content 'Tamanho máximo em centímetros cúbicos não pode ficar em branco'
		expect(page).to have_content 'Peso minímo em gramas não pode ficar em branco'
		expect(page).to have_content 'Peso máximo em gramas não pode ficar em branco'
		expect(page).to have_content 'Preço por quilômetro em centavos não pode ficar em branco'
	end

	it 'com dados inválidos' do
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
		click_on 'Cadastrar nova faixa de preço'
		fill_in 'Tamanho minímo em centímetros cúbicos', with: '-2'
		fill_in 'Tamanho máximo em centímetros cúbicos', with: '-4'
		fill_in 'Peso minímo em gramas', with: '-1'
		fill_in 'Peso máximo em gramas', with: '0'
		fill_in 'Preço por quilômetro em centavos', with: '49'
		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Faixa de preço não cadastrada.'
		expect(page).to have_content 'Tamanho minímo em centímetros cúbicos deve ser maior ou igual a 0'
		expect(page).to have_content 'Tamanho máximo em centímetros cúbicos deve ser maior ou igual a 0'
		expect(page).to have_content 'Peso minímo em gramas deve ser maior ou igual a 0'
		expect(page).to have_content 'Preço por quilômetro em centavos deve ser maior ou igual a 50'
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
		click_on 'Cadastrar nova faixa de preço'
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq carrier_path( acme.id )
	end
end