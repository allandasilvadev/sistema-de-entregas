require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when carrier is empty' do
        # Arrange
        acme = Carrier.create(
          corporate_name: 'ACME LTDA',
          brand_name: 'ACME',
          registration_number: '12242556123245',
          full_address: 'Av. das Nações, 1000',
          city: 'Bauru',
          state: 'SP',
          email_domain: 'acme.com.br',
          activated: true
        )

        ford = Vehicle.new(
          plate: 'ABC4456',
          identification: 'SKU1245638',
          brand: 'Ford',
          mockup: 'C-1731 Tractor',
          year: '2022',
          capacity: '1000'
        )

        # Act
        response = ford.valid?

        # Assert
        expect(response).to eq false
      end

      it 'false when mockup is empty' do
        # Arrange
        acme = Carrier.create(
          corporate_name: 'ACME LTDA',
          brand_name: 'ACME',
          registration_number: '12242556123245',
          full_address: 'Av. das Nações, 1000',
          city: 'Bauru',
          state: 'SP',
          email_domain: 'acme.com.br',
          activated: true
        )

        ford = Vehicle.new(
          plate: 'ABC4456',
          identification: 'SKU1245638',
          brand: 'Ford',
          mockup: '',
          year: '2022',
          capacity: '1000',
          carrier: acme
        )

        # Act
        response = ford.valid?

        # Assert
        expect(response).to eq false
      end

      it 'false when plate is empty' do
        # Arrange
        acme = Carrier.create(
          corporate_name: 'ACME LTDA',
          brand_name: 'ACME',
          registration_number: '12242556123245',
          full_address: 'Av. das Nações, 1000',
          city: 'Bauru',
          state: 'SP',
          email_domain: 'acme.com.br',
          activated: true
        )

        ford = Vehicle.new(
          plate: '',
          identification: 'SKU1245638',
          brand: 'Ford',
          mockup: 'C-1731 Tractor',
          year: '2022',
          capacity: '1000',
          carrier: acme
        )

        # Act
        response = ford.valid?

        # Assert
        expect(response).to eq false
      end

      it 'false when identification is empty' do
        # Arrange
        acme = Carrier.create(
          corporate_name: 'ACME LTDA',
          brand_name: 'ACME',
          registration_number: '12242556123245',
          full_address: 'Av. das Nações, 1000',
          city: 'Bauru',
          state: 'SP',
          email_domain: 'acme.com.br',
          activated: true
        )

        ford = Vehicle.new(
          plate: 'ABC4456',
          identification: '',
          brand: 'Ford',
          mockup: 'C-1731 Tractor',
          year: '2022',
          capacity: '1000',
          carrier: acme
        )

        # Act
        response = ford.valid?

        # Assert
        expect(response).to eq false
      end

      it 'false when capacity is empty' do
        # Arrange
        acme = Carrier.create(
          corporate_name: 'ACME LTDA',
          brand_name: 'ACME',
          registration_number: '12242556123245',
          full_address: 'Av. das Nações, 1000',
          city: 'Bauru',
          state: 'SP',
          email_domain: 'acme.com.br',
          activated: true
        )

        ford = Vehicle.new(
          plate: 'ABC4456',
          identification: 'SKU1245638',
          brand: 'Ford',
          mockup: 'C-1731 Tractor',
          year: '2022',
          capacity: '',
          carrier: acme
        )

        # Act
        response = ford.valid?

        # Assert
        expect(response).to eq false
      end
    end

    context 'length' do
      it 'retorna false se o numero de caracteres da placa informada for diferente de 7' do
        # Arrange
        acme = Carrier.create(
          corporate_name: 'ACME LTDA',
          brand_name: 'ACME',
          registration_number: '12242556123245',
          full_address: 'Av. das Nações, 1000',
          city: 'Bauru',
          state: 'SP',
          email_domain: 'acme.com.br',
          activated: true
        )

        ford = Vehicle.new(
          plate: 'HABC4456',
          identification: 'SKU1245638',
          brand: 'Ford',
          mockup: 'C-1731 Tractor',
          year: '2022',
          capacity: '1000',
          carrier: acme
        )

        # Act
        response = ford.valid?

        # Assert
        expect(response).to eq false
      end
    end

    context 'unique' do
      it 'retorna false se a placa informada nao for unica' do
        # Arrange
        acme = Carrier.create(
          corporate_name: 'ACME LTDA',
          brand_name: 'ACME',
          registration_number: '12242556123245',
          full_address: 'Av. das Nações, 1000',
          city: 'Bauru',
          state: 'SP',
          email_domain: 'acme.com.br',
          activated: true
        )

        ford = Vehicle.create(
          plate: 'ABC4456',
          identification: 'SKU1245638',
          brand: 'Ford',
          mockup: 'C-1731 Tractor',
          year: '2022',
          capacity: '1000',
          carrier: acme
        )

        mercedes = Vehicle.new(
          plate: 'ABC4456',
          identification: 'SKU1245683',
          brand: 'Mercedes',
          mockup: 'C-1244 Tractor',
          year: '2021',
          capacity: '2000',
          carrier: acme
        )

        # Act
        response = mercedes.valid?

        # Assert
        expect(response).to eq false
      end

      it 'retorna false se o identificador informado nao for unico' do
         # Arrange
        acme = Carrier.create(
          corporate_name: 'ACME LTDA',
          brand_name: 'ACME',
          registration_number: '12242556123245',
          full_address: 'Av. das Nações, 1000',
          city: 'Bauru',
          state: 'SP',
          email_domain: 'acme.com.br',
          activated: true
        )

        ford = Vehicle.create(
          plate: 'ABC4465',
          identification: 'SKU1245638',
          brand: 'Ford',
          mockup: 'C-1731 Tractor',
          year: '2022',
          capacity: '1000',
          carrier: acme
        )

        mercedes = Vehicle.new(
          plate: 'ABC4456',
          identification: 'SKU1245638',
          brand: 'Mercedes',
          mockup: 'C-1244 Tractor',
          year: '2021',
          capacity: '2000',
          carrier: acme
        )

        # Act
        response = mercedes.valid?

        # Assert
        expect(response).to eq false
      end
    end
  end
end
