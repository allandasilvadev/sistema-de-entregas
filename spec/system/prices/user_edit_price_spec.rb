require 'rails_helper'

describe 'Usuário edita faixa de preço' do
	it 'a partir da página com a tabela de preços' do
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

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Consultar preços'
		click_on 'Editar'

		# Assert
		expect(page).to have_content('Transportadora: ACME')
		expect(page).to have_content('Editar faixa de preço')
		expect(page).to have_field('Tamanho minímo em centímetros cúbicos', with: '1')
		expect(page).to have_field('Tamanho máximo em centímetros cúbicos', with: '50')
		expect(page).to have_field('Peso minímo em gramas', with: '0')
		expect(page).to have_field('Peso máximo em gramas', with: '10000')
		expect(page).to have_field('Preço por quilômetro em centavos', with: '50')
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

		Price.create!(
			cubic_meter_min: 1, # cm3
			cubic_meter_max: 50, # cm3
			minimum_weight: 0,   # g
			maximum_weight: 10_000, # g
			km_price: 50, # centavos
			carrier: acme
		)

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Consultar preços'
		click_on 'Editar'
		fill_in 'Tamanho máximo em centímetros cúbicos', with: '100'
		fill_in 'Preço por quilômetro em centavos', with: '80'
		click_on 'Enviar'

		# Assert
		expect(current_path).to eq prices_path
		expect(page).to have_content 'Tabela de preços'
		expect(page).to have_content '0.01cm3 a 1cm3'
		expect(page).to have_content '0kg a 10kg'
		expect(page).to have_content 'R$ 0.80'
	end

	it 'e mantém os campos obrigatórios' do
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

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Consultar preços'
		click_on 'Editar'
		fill_in 'Tamanho máximo em centímetros cúbicos', with: ''
		fill_in 'Preço por quilômetro em centavos', with: ''
		click_on 'Enviar'

		# Assert
		expect(page).to have_content('Transportadora: ACME')
		expect(page).to have_content('Editar faixa de preço')
		expect(page).to have_content('Não foi possível atualizar a faixa de preço.')
		expect(page).to have_content('Tamanho máximo em centímetros cúbicos não pode ficar em branco')
		expect(page).to have_content('Preço por quilômetro em centavos não pode ficar em branco')
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

		Price.create!(
			cubic_meter_min: 1, # cm3
			cubic_meter_max: 50, # cm3
			minimum_weight: 0,   # g
			maximum_weight: 10_000, # g
			km_price: 50, # centavos
			carrier: acme
		)

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Consultar preços'
		click_on 'Editar'
		fill_in 'Tamanho máximo em centímetros cúbicos', with: '-4'
		fill_in 'Preço por quilômetro em centavos', with: '40'
		click_on 'Enviar'

		# Assert
		expect(page).to have_content('Transportadora: ACME')
		expect(page).to have_content('Editar faixa de preço')
		expect(page).to have_content('Não foi possível atualizar a faixa de preço.')
		expect(page).to have_content('Tamanho máximo em centímetros cúbicos deve ser maior ou igual a 0')
		expect(page).to have_content('Preço por quilômetro em centavos deve ser maior ou igual a 50')
	end

	it 'ou volta para listagem de preços' do
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

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Consultar preços'
		click_on 'Editar'
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq prices_path
	end
end