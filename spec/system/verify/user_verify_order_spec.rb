require 'rails_helper'

describe 'Usuário não autenticado consulta sua ordem de serviço' do
	it 'a partir da página inicial' do
		# Arrange
		# Act
		visit root_path
		within('nav') do
			click_on 'Consultar sua entrega'
		end

		# Assert
		expect(current_path).to eq open_orders_path
		expect(page).to have_content 'Consultar o status de sua entrega'
		expect(page).to have_content 'Informe no formulário abaixo o código de sua entrega'
		expect(page).to have_field 'Código da entrega'
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

		ford = Vehicle.create!(
			plate: 'ABC4456',
			identification: 'SKU1245638',
			brand: 'Ford',
			mockup: 'C-1731 Tractor',
			year: '2022',
			capacity: '1000',
			carrier: acme
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
			status: 'in_progress',
			code: 'ORDER1234567891',
			carrier: acme,
			vehicle: ford,
			date_and_time: '23/05/2022 10:22'
		)

		# Act
		visit root_path
		within('nav') do
			click_on 'Consultar sua entrega'
		end
		fill_in 'Código da entrega', with: 'ORDER1234567891'
		click_on 'Enviar'

		# Assert
		expect(current_path).to eq open_orders_path

		# dados  da ordem de serviço
		expect(page).to have_content 'Status da sua entrega'

		expect(page).to have_content 'Código: ORDER1234567891'
		expect(page).to have_content 'Localização: Av. das Nações, 1000'
		expect(page).to have_content 'Endereço de entrega: Rua das Flores, 26 - Bauru - SP'
		expect(page).to have_content 'Nome do destinatário: Maria'
		expect(page).to have_content 'Cpf do destinatário: 12344567890'
		expect(page).to have_content 'Status: Em andamento'
		expect(page).to have_content 'Data da última atualização: 23/05/2022 10:22'
	end

	it 'e digita o código incorreto' do
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

		ford = Vehicle.create!(
			plate: 'ABC4456',
			identification: 'SKU1245638',
			brand: 'Ford',
			mockup: 'C-1731 Tractor',
			year: '2022',
			capacity: '1000',
			carrier: acme
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
			status: 'in_progress',
			code: 'ORDER1234567891',
			carrier: acme,
			vehicle: ford,
			date_and_time: '23/05/2022 10:22'
		)

		# Act
		visit root_path
		within('nav') do
			click_on 'Consultar sua entrega'
		end
		fill_in 'Código da entrega', with: 'ORDER123456789B'
		click_on 'Enviar'

		# Assert
		expect(current_path).to eq open_orders_path

		# dados  da ordem de serviço
		expect(page).to have_content 'O código informado está incorreto.'
	end

	it 'e volta para tela inicial' do
		# Arrange
		# Act
		visit root_path
		within('nav') do
			click_on 'Consultar sua entrega'
		end
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq root_path
	end
end