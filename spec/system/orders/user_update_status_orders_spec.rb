require 'rails_helper'

describe 'Usuário da transportadora atualiza status da ordem de serviço' do
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

		ford = Vehicle.create!(
			plate: 'ABC5644',
			identification: 'SKU2424567',
			brand: 'Ford',
			mockup: 'C-1244 Tractor',
			year: '2021',
			capacity: '2000',
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
			status: 'aceita',
			code: 'ORDER1234567891',
			carrier: acme,
			vehicle: ford
		)

		# Act
		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Ordens de serviço'
		click_on 'ORDER1234567891'
		click_on 'Atualizar status e localização da ordem de serviço'

		# Assert
		expect(current_path).to eq order_update_status_path( order.id )
		expect(page).to have_content 'Transportadora: ACME'
		expect(page).to have_content 'Ordem de serviço: ORDER1234567891'
		expect(page).to have_content 'Localização atual: Av. das Nações, 1000'
		expect(page).to have_content 'Status atual: aceita'
		expect(page).to have_content 'Mais informações'

		expect(page).to have_field 'Status', with: 'aceita'
		expect(page).to have_field 'Localização', with: 'Av. das Nações, 1000'
		expect(page).to have_field 'Data da última atualização'
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
			plate: 'ABC5644',
			identification: 'SKU2424567',
			brand: 'Ford',
			mockup: 'C-1244 Tractor',
			year: '2021',
			capacity: '2000',
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
			status: 'aceita',
			code: 'ORDER1234567891',
			carrier: acme,
			vehicle: ford
		)

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Ordens de serviço'
		click_on 'ORDER1234567891'
		click_on 'Atualizar status e localização da ordem de serviço'
		fill_in 'Localização', with: 'Rua das Amoreiras, 4000 - Limeira - SP'
		fill_in 'Data da última atualização', with: '23/05/2022 09:10'
		select 'Em andamento', from: 'Status'
		click_on 'Enviar'

		# Assert

		expect(current_path).to eq order_path( order.id )
		expect(page).to have_content 'A localização e o status da ordem de serviço foram atualizadas com sucesso.'
		expect(page).to have_content 'Transportadora: ACME'
		expect(page).to have_content 'Código: ORDER1234567891'
		expect(page).to have_content 'Localização: Rua das Amoreiras, 4000 - Limeira - SP'
		expect(page).to have_content 'Status: Em andamento'
		expect(page).to have_content 'Data da última atualização: 23/05/2022 09:10'
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

		ford = Vehicle.create!(
			plate: 'ABC5644',
			identification: 'SKU2424567',
			brand: 'Ford',
			mockup: 'C-1244 Tractor',
			year: '2021',
			capacity: '2000',
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
			status: 'aceita',
			code: 'ORDER1234567891',
			carrier: acme,
			vehicle: ford
		)

		# Act
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Ordens de serviço'
		click_on 'ORDER1234567891'
		click_on 'Atualizar status e localização da ordem de serviço'
		fill_in 'Localização', with: ''
		fill_in 'Data da última atualização', with: ''
		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Não foi possível atualizar o status da ordem de serviço.'
		expect(page).to have_content 'Transportadora: ACME'
		expect(page).to have_content 'Localização não pode ficar em branco'
	end

	it 'ou volta para tela onde as ordens de serviço de sua transportadora são listadas' do
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

		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Ordens de serviço'
		click_on 'ORDER1234567891'
		click_on 'Atualizar status e localização da ordem de serviço'
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq order_path( order.id )
	end


end