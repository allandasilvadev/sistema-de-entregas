require 'rails_helper'

describe 'Usuário vê todas as ordens de serviço' do
	# para administradores
	it 'ADM: a partir da página para administradores' do
		# Arrage
		Carrier.create!(
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
			name: 'João da Silva',
			email: 'joao@email.com',
			password: '123456',
			role: 'administrator'
		)

		# Act
		login_as(user)
		visit root_path
		within('nav') do
			click_on 'Visualizar ordens de serviço'
		end

		# Assert
		expect(current_path).to eq all_orders_path
	end

	it 'ADM: a partir da página para administradores, mas não é um administrador' do
		# Arrage
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
			name: 'João da Silva',
			email: 'joao@email.com',
			password: '123456',
			role: 'carrier',
			carrier_id: acme.id
		)

		# Act
		login_as(user)
		visit root_path
		visit all_orders_path

		# Assert
		expect(current_path).to eq orders_path
		expect(page).to have_content 'Você não pode visualizar ordens de serviço de outras transportadoras.'
	end

	# adiministradores poderao ver ordens de serviço de todas as transportadoras
	it 'ADM: com sucesso' do
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

		star = Carrier.create!(
			corporate_name: 'Star LTDA',
			brand_name: 'Star',
			registration_number: '12242556123254',
			full_address: 'Av. das Palmas, 8000',
			city: 'Salvador',
			state: 'BA',
			email_domain: 'star.com',
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
			carrier: star
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

		# Assert
		expect(current_path).to eq all_orders_path

		expect(page).to have_content 'Ordens de serviço'

		expect(page).to have_content 'Código: ORDER1234567819'
		expect(page).to have_content 'Endereço de coleta: Av. das Nações, 1000'
		expect(page).to have_content 'Volume: 0.036m3'
		expect(page).to have_content 'Peso: 8kg'
		expect(page).to have_content 'Distância: 40km'
		expect(page).to have_content 'Localização: Av. das Nações, 1000'
		expect(page).to have_content 'Endereço de entrega: Rua das Palmas, 48 - Salvador - BA'
		expect(page).to have_content 'Status: pendente'
		expect(page).to have_content 'Transportadora: Star'

		expect(page).to have_content 'Código: ORDER1234567891'
		expect(page).to have_content 'Endereço de coleta: Av. das Nações, 1000'
		expect(page).to have_content 'Volume: 0.036m3'
		expect(page).to have_content 'Peso: 8kg'
		expect(page).to have_content 'Distância: 20km'
		expect(page).to have_content 'Localização: Av. das Nações, 1000'
		expect(page).to have_content 'Endereço de entrega: Rua das Flores, 26 - Bauru - SP'
		expect(page).to have_content 'Status: pendente'
		expect(page).to have_content 'Transportadora: ACME'
	end

	it 'ADM: e não existem ordens de serviço cadastradas.' do
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

		# Assert
		expect(current_path).to eq all_orders_path
		expect(page).to have_content 'Ordens de serviço'
		expect(page).to have_content 'Não existem ordens de serviço cadastradas.'
	end

	it 'a partir da página de detalhes de uma transportadora' do
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
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Ordens de serviço'

		# Assert
		expect(current_path).to eq orders_path
	end

	it 'e não vê ordens de serviço de outras transportadoras' do
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

		star = Carrier.create!(
			corporate_name: 'Star LTDA',
			brand_name: 'Star',
			registration_number: '12242556123282',
			full_address: 'Av. das Flores, 3200',
			city: 'Limeira',
			state: 'SP',
			email_domain: 'star.com',
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
		within('nav') do
			click_on 'Transportadoras'
		end
		visit orders_path( carrier_id: star.id )

		# Assert
		expect(current_path).to eq orders_path
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
		click_on 'Ordens de serviço'

		# Assert
		expect(current_path).to eq orders_path
		expect(page).to have_content 'Transportadora: ACME'
		expect(page).to have_content 'Ordens de serviço'

		expect(page).to have_content 'Código: ORDER1234567891'
		expect(page).to have_content 'Endereço de coleta: Av. das Nações, 1000'
		expect(page).to have_content 'Volume: 0.036m3'
		expect(page).to have_content 'Peso: 8kg'
		expect(page).to have_content 'Distância: 20km'
		expect(page).to have_content 'Localização: Av. das Nações, 1000'
		expect(page).to have_content 'Endereço de entrega: Rua das Flores, 26 - Bauru - SP'
		expect(page).to have_content 'Status: pendente'

		expect(page).to have_content 'Código: ORDER1234567819'
		expect(page).to have_content 'Endereço de coleta: Av. das Nações, 1000'
		expect(page).to have_content 'Volume: 0.036m3'
		expect(page).to have_content 'Peso: 8kg'
		expect(page).to have_content 'Distância: 40km'
		expect(page).to have_content 'Localização: Av. das Nações, 1000'
		expect(page).to have_content 'Endereço de entrega: Rua das Palmas, 48 - Salvador - BA'
		expect(page).to have_content 'Status: pendente'
	end

	it 'e não vê ordens de serviço de outras transportadoras' do
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

		star = Carrier.create!(
			corporate_name: 'Star LTDA',
			brand_name: 'Star',
			registration_number: '12242556123254',
			full_address: 'Av. das Palmas, 8000',
			city: 'Salvador',
			state: 'BA',
			email_domain: 'star.com',
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
			carrier: star
		)

		user = User.create!(
			name: 'Maria',
			email: 'maria@email.com',
			password: '123456',
			role: 'carrier',
			carrier_id: star.id
		)

		# Act
		login_as(user)
		visit root_path
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'Star'
		click_on 'Ordens de serviço'

		# Assert
		expect(current_path).to eq orders_path
		expect(page).to have_content 'Transportadora: Star'
		expect(page).to have_content 'Ordens de serviço'

		expect(page).to have_content 'Código: ORDER1234567819'
		expect(page).to have_content 'Endereço de coleta: Av. das Nações, 1000'
		expect(page).to have_content 'Volume: 0.036m3'
		expect(page).to have_content 'Peso: 8kg'
		expect(page).to have_content 'Distância: 40km'
		expect(page).to have_content 'Localização: Av. das Nações, 1000'
		expect(page).to have_content 'Endereço de entrega: Rua das Palmas, 48 - Salvador - BA'
		expect(page).to have_content 'Status: pendente'

		expect(page).not_to have_content 'Código: ORDER1234567891'
	end

	it 'e não existem ordens de serviço' do
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
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Ordens de serviço'

		# Assert
		expect(current_path).to eq orders_path
		expect(page).to have_content 'Transportadora: ACME'
		expect(page).to have_content 'Ordens de serviço'
		expect(page).to have_content 'Não existem ordens de serviço para esta transportadora.'
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
		within('nav') do
			click_on 'Transportadoras'
		end
		click_on 'ACME'
		click_on 'Ordens de serviço'
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq carrier_path(acme.id)
	end
end