require 'rails_helper'

describe 'Usuário vê tela inicial' do
	it 'e vê nome da aplicação' do
		# Arrange
		# Act
		visit root_path

		# Assert
		expect(page).to have_content('Sistema de entregas')
	end
end