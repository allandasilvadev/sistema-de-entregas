require 'rails_helper'

describe 'Usuário remove uma ordem de serviço' do
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
		within("#del-#{order.id}") do
			click_on 'Remover'
		end

		# Assert
		expect(current_path).to eq all_orders_path
		expect(page).to have_content 'Ordem de serviço excluída com sucesso.'
		expect(page).not_to have_content 'Código: ORDER1234567891'
	end

	it 'e não remove outras ordens de serviço' do
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

		Order.create!(
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
		within("#del-#{order.id}") do
			click_on 'Remover'
		end

		# Assert
		expect(current_path).to eq all_orders_path
		expect(page).to have_content 'Ordem de serviço excluída com sucesso.'
		expect(page).not_to have_content 'Código: ORDER1234567891'
		expect(page).to have_content 'Código: ORDER1234567819'
	end
end