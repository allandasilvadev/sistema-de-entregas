require 'rails_helper'

RSpec.describe Carrier, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when corporate_name is empty' do
        # Arrange
        carrier = Carrier.new(
          corporate_name: '',
          brand_name: 'ACME',
          registration_number: '12242556123245',
          full_address: 'Av. das Nações, 1000',
          city: 'Bauru',
          state: 'SP',
          email_domain: 'acme.com.br',
          activated: true
        )

        # Act
        response = carrier.valid?

        # Assert
        expect(response).to eq false
      end

      it 'false when registration_number is empty' do
        # Arrange
        carrier = Carrier.new(
          corporate_name: 'ACME LTDA',
          brand_name: 'ACME',
          registration_number: '',
          full_address: 'Av. das Nações, 1000',
          city: 'Bauru',
          state: 'SP',
          email_domain: 'acme.com.br',
          activated: true
        )

        # Act
        response = carrier.valid?

        # Assert
        expect(response).to eq false
      end

      it 'false when email_domain is empty' do
        # Arrange
        carrier = Carrier.new(
          corporate_name: 'ACME LTDA',
          brand_name: 'ACME',
          registration_number: '12242556123245',
          full_address: 'Av. das Nações, 1000',
          city: 'Bauru',
          state: 'SP',
          email_domain: '',
          activated: true
        )

        # Act
        response = carrier.valid?

        # Assert
        expect(response).to eq false
      end
    end


    context 'length' do
      it 'retorna false se o registration_number tem o tamanho diferente de 14' do
        # Arrange
        carrier = Carrier.new(
          corporate_name: 'ACME LTDA',
          brand_name: 'ACME',
          registration_number: '123',
          full_address: 'Av. das Nações, 1000',
          city: 'Bauru',
          state: 'SP',
          email_domain: 'acme.com.br',
          activated: true
        )

        # Act
        response = carrier.valid?

        # Assert
        expect(response).to eq false
      end
    end

    context 'unique' do
      it 'retorna false se o registration_number não for unico' do
        # Arrange
        acme = Carrier.create(
            corporate_name: 'ACME LTDA',
            brand_name: 'ACME',
            registration_number: '12242556123254',
            full_address: 'Av. das Nações, 1000',
            city: 'Bauru',
            state: 'SP',
            email_domain: 'acme.com.br',
            activated: true
          )

        star = Carrier.new(
            corporate_name: 'Star LTDA',
            brand_name: 'Star',
            registration_number: '12242556123254',
            full_address: 'Av. das Palmas, 4000',
            city: 'Salvador',
            state: 'BA',
            email_domain: 'star.com',
            activated: true
          )

        # Act
        response = star.valid?

        # Assert
        expect(response).to eq false
      end
    end

  end
end
