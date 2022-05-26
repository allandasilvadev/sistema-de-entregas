require 'rails_helper'

describe 'Usuário cadastra uma nova ordem de serviço' do
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
			click_on 'Cadastrar nova ordem de serviço'
		end

		# Assert
		# Observações
		# status - sempre será cadastrado como pendente
		# vehicle - sempre será iniciado como vazio, podendo ser alterado somente pela transportadora
		# location por default comecara como o endereço de coleta podendo ser alterado somente pela transportadora

		expect(current_path).to eq new_order_path
		expect(page).to have_content 'Cadastrar nova ordem de serviço'

		expect(page).to have_field 'Endereço de coleta'

		expect(page).to have_field 'Código do produto'
		expect(page).to have_field 'Altura em centímetros'
		expect(page).to have_field 'Largura em centímetros'
		expect(page).to have_field 'Profundidade em centímetros'
		expect(page).to have_field 'Peso em gramas'

		expect(page).to have_field 'Endereço de entrega'
		expect(page).to have_field 'Nome do destinatário'
		expect(page).to have_field 'Cpf do destinatário'

		expect(page).to have_field 'Código da ordem de serviço'
		expect(page).to have_field 'Distância em metros'
		expect(page).to have_field 'Transportadora'
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
			click_on 'Cadastrar nova ordem de serviço'
		end
		fill_in 'Endereço de coleta', with: 'Av. das Nações, 1000'
		fill_in 'Código do produto', with: 'SAMSU-12345'
		fill_in 'Altura', with: '60'
		fill_in 'Largura', with: '60'
		fill_in 'Profundidade', with: '10'
		fill_in 'Peso em gramas', with: '8000'
		fill_in 'Endereço de entrega', with: 'Rua das Flores, 240 - Bauru - SP'
		fill_in 'Nome do destinatário', with: 'Maria'
		fill_in 'Cpf do destinatário', with: '12344567890'
		fill_in 'Código da ordem de serviço', with: 'ORDER1234567891'
		fill_in 'Distância em metros', with: '20_000'
		select 'ACME', from: 'Transportadora'
		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Ordem de serviço criada com sucesso.'

		expect(page).to have_content 'Código: ORDER1234567891'
		expect(page).to have_content 'Endereço de coleta: Av. das Nações, 1000'
		expect(page).to have_content 'Código do produto: SAMSU-12345'
		expect(page).to have_content 'Altura: 60cm'
		expect(page).to have_content 'Largura: 60cm'
		expect(page).to have_content 'Profundidade: 10cm'
		expect(page).to have_content 'Volume: 0.036m3'
		expect(page).to have_content 'Peso: 8kg'
		expect(page).to have_content 'Distância: 20km'
		expect(page).to have_content 'Localização: Av. das Nações, 1000'
		expect(page).to have_content 'Endereço de entrega: Rua das Flores, 240 - Bauru - SP'
		expect(page).to have_content 'Nome do destinatário: Maria'
		expect(page).to have_content 'Cpf do destinatário: 12344567890'
		expect(page).to have_content 'Status: pendente'
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
			click_on 'Cadastrar nova ordem de serviço'
		end
		fill_in 'Endereço de coleta', with: ''
		fill_in 'Endereço de entrega', with: ''
		fill_in 'Código da ordem de serviço', with: 'ORDER1234567891'
		fill_in 'Distância em metros', with: '20_000'
		select 'ACME', from: 'Transportadora'
		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Não foi possível criar a ordem de serviço.'

		expect(page).to have_content 'Endereço de coleta não pode ficar em branco'
		expect(page).to have_content 'Endereço de entrega não pode ficar em branco'
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

		Order.create!(
			collection_address: 'Av. das Nações, 1000',
			sku_product: 'SAMSU-12345',
			height: '60',
			width: '60',
			depth: '10',
			weight: '8000',
			distance: '20_000',
			location: 'Av. das Nações, 1000',
			delivery_address: 'Rua das Flores, 26 - Bauru - SP',
			recipient_name: 'Maria',
			recipient_cpf: '12344567890',
			status: 'pendente',
			code: 'ORDER1234567891',
			carrier: acme
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
			click_on 'Cadastrar nova ordem de serviço'
		end
		fill_in 'Endereço de coleta', with: 'Av. das Nações, 1000'
		fill_in 'Código do produto', with: 'SAMSU-12345'
		fill_in 'Altura', with: '0'
		fill_in 'Largura', with: '0'
		fill_in 'Profundidade', with: '-12'
		fill_in 'Peso em gramas', with: '0'
		fill_in 'Endereço de entrega', with: 'Rua das Flores, 240 - Bauru - SP'
		fill_in 'Nome do destinatário', with: 'Maria'
		fill_in 'Cpf do destinatário', with: '12344567890'
		fill_in 'Código da ordem de serviço', with: 'ORDER1234567891'
		fill_in 'Distância em metros', with: '0'
		select 'ACME', from: 'Transportadora'
		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Não foi possível criar a ordem de serviço.'
		expect(page).to have_content 'Código da ordem de serviço já está em uso'
		expect(page).to have_content  'Altura em centímetros deve ser maior que 0'
		expect(page).to have_content  'Largura em centímetros deve ser maior que 0'
		expect(page).to have_content  'Profundidade em centímetros deve ser maior que 0'
		expect(page).to have_content  'Peso em gramas deve ser maior que 0'
		expect(page).to have_content  'Distância em metros deve ser maior que 0'
	end

	it 'ou volta para tela onde todas as ordens de serviço são listadas' do
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
			click_on 'Cadastrar nova ordem de serviço'
		end
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq orders_all_path
	end
end