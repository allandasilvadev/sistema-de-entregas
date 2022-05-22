require 'rails_helper'

describe 'Usuário vê detalhes de uma ordem de serviço' do
	it 'ADM: e vê informações adicionais' do
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

		# Act
		visit root_path
		within('nav') do
			click_on 'Visualizar ordens de serviço'
		end
		click_on 'ORDER1234567891'

		# Assert
		expect(current_path).to eq order_get_path( order.id )
		expect(page).to have_content 'Ordens de serviço'

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
		expect(page).to have_content 'Endereço de entrega: Rua das Flores, 26 - Bauru - SP'
		expect(page).to have_content 'Nome do destinatário: Maria'
		expect(page).to have_content 'Cpf do destinatário: 12344567890'
		expect(page).to have_content 'Status: pendente'
	end

	it 'ADM: e volta para tela onde TODAS as ordens de serviço são listadas' do
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

		# Act
		visit root_path
		within('nav') do
			click_on 'Visualizar ordens de serviço'
		end
		click_on 'ORDER1234567891'
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq orders_all_path
	end

	it 'e vê informações adicionais' do
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

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Ordens de serviço'
		click_on 'ORDER1234567891'

		# Assert
		expect(current_path).to eq order_path( order.id )
		expect(page).to have_content 'Transportadora: ACME'
		expect(page).to have_content 'Ordens de serviço'

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
		expect(page).to have_content 'Endereço de entrega: Rua das Flores, 26 - Bauru - SP'
		expect(page).to have_content 'Nome do destinatário: Maria'
		expect(page).to have_content 'Cpf do destinatário: 12344567890'
		expect(page).to have_content 'Status: pendente'
	end

	it 'e volta para tela onde as ordens de serviço da transportadora são litadas' do
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

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Ordens de serviço'
		click_on 'ORDER1234567891'
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq orders_path
	end
end