require 'rails_helper'

describe 'Usuário edita ordens de serviço' do
	it 'a partir da página onde as ordens de serviço são listadas' do
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

		second = Order.create!(
			collection_address: 'Av. das Nações, 1000',
			sku_product: 'SAMSU-12345',
			height: '60',
			width: '60',
			depth: '10',
			weight: '8000',
			distance: '40_000',
			location: 'Av. das Nações, 1000',
			delivery_address: 'Rua das Palmas, 48 - Salvador - BA',
			recipient_name: 'Paulo',
			recipient_cpf: '12344567884',
			status: 'pendente',
			code: 'ORDER1234567819',
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
			click_on 'Visualizar ordens de serviço'
		end
		within("#orderid-#{second.id}") do
			click_on 'Editar'
		end

		# Assert
		expect(page).to have_content 'Editar ordem de serviço: ORDER1234567819'
		expect(page).to have_field 'Distância em metros', with: '40000'
		expect(page).to have_field 'Endereço de entrega', with: 'Rua das Palmas, 48 - Salvador - BA'
		expect(page).to have_field 'Nome do destinatário', with: 'Paulo'
		expect(page).to have_field 'Cpf do destinatário', with: '12344567884'
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

		Carrier.create!(
			corporate_name: 'Star LTDA',
			brand_name: 'Star',
			registration_number: '12242556123282',
			full_address: 'Av. das Mangueiras, 8000',
			city: 'São Paulo',
			state: 'SP',
			email_domain: 'star',
			activated: true
		)

		order = Order.create!(
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
			click_on 'Visualizar ordens de serviço'
		end
		within("#orderid-#{order.id}") do
			click_on 'Editar'
		end

		fill_in 'Distância em metros', with: '45_000'
		fill_in 'Endereço de entrega', with: 'Rua das Figueiras, 160 - Salvador - BA'
		fill_in 'Nome do destinatário', with: 'Carla'
		fill_in 'Cpf do destinatário', with: '12344567848'
		select 'Star', from: 'Transportadora'

		click_on 'Enviar'

		# Assert
		expect(current_path).to eq order_get_path( order.id )
		expect(page).to have_content 'Ordens de serviço'
		expect(page).to have_content 'Ordem de serviço atualizada com sucesso.'

		expect(page).to have_content 'Código: ORDER1234567891'
		expect(page).to have_content 'Endereço de coleta: Av. das Nações, 1000'
		expect(page).to have_content 'Código do produto: SAMSU-12345'
		expect(page).to have_content 'Altura: 60cm'
		expect(page).to have_content 'Largura: 60cm'
		expect(page).to have_content 'Profundidade: 10cm'
		expect(page).to have_content 'Volume: 0.036m3'
		expect(page).to have_content 'Peso: 8kg'
		expect(page).to have_content 'Distância: 45km'
		expect(page).to have_content 'Localização: Av. das Nações, 1000'
		expect(page).to have_content 'Endereço de entrega: Rua das Figueiras, 160 - Salvador - BA'
		expect(page).to have_content 'Nome do destinatário: Carla'
		expect(page).to have_content 'Cpf do destinatário: 12344567848'
		expect(page).to have_content 'Status: pendente'
	end

	it 'e a ordem de serviço já foi aceita pela transportadora' do
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

		order = Order.create!(
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
			status: 'aceita',
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
			click_on 'Visualizar ordens de serviço'
		end
		within("#orderid-#{order.id}") do
			click_on 'Editar'
		end

		# Assert
		expect(current_path).to eq order_get_path( order.id )
		expect(page).to have_content 'Ordens de serviço'
		expect(page).to have_content 'Ordens aceitas pelas transportadoras não podem ser editadas.'
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

		Carrier.create!(
			corporate_name: 'Star LTDA',
			brand_name: 'Star',
			registration_number: '12242556123282',
			full_address: 'Av. das Mangueiras, 8000',
			city: 'São Paulo',
			state: 'SP',
			email_domain: 'star',
			activated: true
		)

		order = Order.create!(
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
			click_on 'Visualizar ordens de serviço'
		end
		within("#orderid-#{order.id}") do
			click_on 'Editar'
		end

		fill_in 'Distância em metros', with: ''
		fill_in 'Endereço de entrega', with: ''
		fill_in 'Nome do destinatário', with: ''
		fill_in 'Cpf do destinatário', with: ''

		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Editar ordem de serviço: ORDER1234567891'
		expect(page).to have_content 'Não foi possivel atualizar a ordem de serviço.'
		expect(page).to have_content 'Endereço de entrega não pode ficar em branco'
		expect(page).to have_content 'Nome do destinatário não pode ficar em branco'
		expect(page).to have_content 'Cpf do destinatário não pode ficar em branco'

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

		order = Order.create!(
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
			click_on 'Visualizar ordens de serviço'
		end
		within("#orderid-#{order.id}") do
			click_on 'Editar'
		end

		fill_in 'Distância em metros', with: '0'
		fill_in 'Cpf do destinatário', with: '12'

		click_on 'Enviar'


		# Assert
		expect(page).to have_content 'Editar ordem de serviço: ORDER1234567891'
		expect(page).to have_content 'Não foi possivel atualizar a ordem de serviço.'
		expect(page).to have_content 'Distância em metros deve ser maior que 0'
		expect(page).to have_content 'Cpf do destinatário não possui o tamanho esperado (11 caracteres)'
	end

	it 'ou volta para tela onde TODAS as ordens de serviço são listadas' do
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

		order = Order.create!(
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
			click_on 'Visualizar ordens de serviço'
		end
		within("#orderid-#{order.id}") do
			click_on 'Editar'
		end
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq order_get_path( order.id )
	end
end