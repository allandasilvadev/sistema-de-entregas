require 'rails_helper'

describe 'Usuário faz uma consulta de preços' do
	it 'a partir da página inicial' do
		# Arrange
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
			click_on 'Consultar preços'
		end

		# Assert
		expect(current_path).to eq prices_request_index_path

		expect(page).to have_content 'Consultar preços'
		expect(page).to have_field 'Altura em centímetros'
		expect(page).to have_field 'Largura em centímetros'
		expect(page).to have_field 'Profundidade em centímetros'
		expect(page).to have_field 'Peso em gramas'
		expect(page).to have_field 'Distância em metros'
	end

	it 'a partir da página inicial, mas não é um administrador' do
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
		# within('nav') do
		#	  click_on 'Consultar preços'
		# end
		visit prices_request_index_path

		# Assert
		expect(current_path).to eq root_path
		expect(page).to have_content 'Somente administradores podem fazer consultas de preços.'
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
			carrier: acme,
			minimum_distance: 0,
			maximum_distance: 10_000
		)

		star = Carrier.create!(
			corporate_name: 'Star LTDA',
			brand_name: 'Star',
			registration_number: '12242556123254',
			full_address: 'Av. das Palmas, 1000',
			city: 'Salvador',
			state: 'BA',
			email_domain: 'star.com',
			activated: true
		)

		Price.create!(
			cubic_meter_min: 1, # cm3
			cubic_meter_max: 50, # cm3
			minimum_weight: 0,   # g
			maximum_weight: 10_000, # g
			km_price: 50, # centavos
			carrier: star,
			minimum_distance: 10_000,
			maximum_distance: 20_000
		)

		wayne = Carrier.create!(
			corporate_name: 'Wayne LTDA',
			brand_name: 'Wayne',
			registration_number: '12242556123222',
			full_address: 'Rua da Mangueiras, 4080',
			city: 'Limeira',
			state: 'SP',
			email_domain: 'wayne.com.br',
			activated: true
		)

		Price.create!(
			cubic_meter_min: 1, # cm3
			cubic_meter_max: 50, # cm3
			minimum_weight: 0,   # g
			maximum_weight: 10_000, # g
			km_price: 75, # centavos
			carrier: wayne,
			minimum_distance: 10_000,
			maximum_distance: 60_000
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
			click_on 'Consultar preços'
		end
		fill_in 'Altura em centímetros', with: '60'
		fill_in 'Largura em centímetros', with: '60'
		fill_in 'Profundidade em centímetros', with: '10'
		fill_in 'Peso em gramas', with: '8000'
		fill_in 'Distância em metros', with: '10000'
		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Transportadora: Star'
		expect(page).to have_content 'Volume: 0.01cm3 a 0.5cm3'
		expect(page).to have_content 'Peso: 0kg a 10kg'
		expect(page).to have_content 'Preço: R$ 0.50'
		expect(page).to have_content 'Preço da entrega: R$ 5.00'

		expect(page).to have_content 'Transportadora: Wayne'
		expect(page).to have_content 'Volume: 0.01cm3 a 0.5cm3'
		expect(page).to have_content 'Peso: 0kg a 10kg'
		expect(page).to have_content 'Preço: R$ 0.50'
		expect(page).to have_content 'Preço da entrega: R$ 7.50'
	end

	it 'e não preenche todos os campos' do
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
			carrier: acme,
			minimum_distance: 0,
			maximum_distance: 10_000
		)

		star = Carrier.create!(
			corporate_name: 'Star LTDA',
			brand_name: 'Star',
			registration_number: '12242556123254',
			full_address: 'Av. das Palmas, 1000',
			city: 'Salvador',
			state: 'BA',
			email_domain: 'star.com',
			activated: true
		)

		Price.create!(
			cubic_meter_min: 1, # cm3
			cubic_meter_max: 50, # cm3
			minimum_weight: 0,   # g
			maximum_weight: 10_000, # g
			km_price: 50, # centavos
			carrier: star,
			minimum_distance: 10_000,
			maximum_distance: 20_000
		)

		wayne = Carrier.create!(
			corporate_name: 'Wayne LTDA',
			brand_name: 'Wayne',
			registration_number: '12242556123222',
			full_address: 'Rua da Mangueiras, 4080',
			city: 'Limeira',
			state: 'SP',
			email_domain: 'wayne.com.br',
			activated: true
		)

		Price.create!(
			cubic_meter_min: 1, # cm3
			cubic_meter_max: 50, # cm3
			minimum_weight: 0,   # g
			maximum_weight: 10_000, # g
			km_price: 75, # centavos
			carrier: wayne,
			minimum_distance: 10_000,
			maximum_distance: 60_000
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
			click_on 'Consultar preços'
		end
		fill_in 'Altura em centímetros', with: ''
		fill_in 'Largura em centímetros', with: ''
		fill_in 'Profundidade em centímetros', with: ''
		fill_in 'Peso em gramas', with: '8000'
		fill_in 'Distância em metros', with: '10000'
		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Você deve preencher todos os campos para fazer a consulta.'
	end

	it 'e salva o orçamento no banco de dados, com sucesso' do
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
			carrier: acme,
			minimum_distance: 0,
			maximum_distance: 10_000
		)

		star = Carrier.create!(
			corporate_name: 'Star LTDA',
			brand_name: 'Star',
			registration_number: '12242556123254',
			full_address: 'Av. das Palmas, 1000',
			city: 'Salvador',
			state: 'BA',
			email_domain: 'star.com',
			activated: true
		)

		Price.create!(
			cubic_meter_min: 1, # cm3
			cubic_meter_max: 50, # cm3
			minimum_weight: 0,   # g
			maximum_weight: 10_000, # g
			km_price: 50, # centavos
			carrier: star,
			minimum_distance: 10_000,
			maximum_distance: 20_000
		)

		wayne = Carrier.create!(
			corporate_name: 'Wayne LTDA',
			brand_name: 'Wayne',
			registration_number: '12242556123222',
			full_address: 'Rua da Mangueiras, 4080',
			city: 'Limeira',
			state: 'SP',
			email_domain: 'wayne.com.br',
			activated: true
		)

		Price.create!(
			cubic_meter_min: 1, # cm3
			cubic_meter_max: 50, # cm3
			minimum_weight: 0,   # g
			maximum_weight: 10_000, # g
			km_price: 75, # centavos
			carrier: wayne,
			minimum_distance: 10_000,
			maximum_distance: 60_000
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
			click_on 'Consultar preços'
		end
		fill_in 'Altura em centímetros', with: '60'
		fill_in 'Largura em centímetros', with: '60'
		fill_in 'Profundidade em centímetros', with: '10'
		fill_in 'Peso em gramas', with: '8000'
		fill_in 'Distância em metros', with: '10000'
		click_on 'Enviar'

		within("div#save-1") do
			click_on 'Salvar'
		end

		# Assert
		expect(current_path).to eq prices_request_index_path
		expect(page).to have_content 'Consulta de preço salva com sucesso.'
	end

	it 'e volta para tela inicial' do
		# Assert
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
			click_on 'Consultar preços'
		end
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq root_path
	end

end