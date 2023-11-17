require 'rails_helper'

describe '::Owner altera Quarto' do
  context 'a partir da página de Pousada' do
    it 'clicando em Editar' do
      # Arrange
      @owner = make_owner
      @inn = make_inn(@owner)
      @room = make_room(@inn)
      visit root_path
      login(@owner)
      click_on 'Minha Pousada'
      # Act
      first('button', text: 'Editar Quarto').click
      # Assert
      expect(page).to have_field('Nome')
      expect(page).to have_field('Descrição')
      expect(page).to have_field('Área (m²)')
      expect(page).to have_field('Hóspedes')
      expect(page).to have_field('Preço Base')
      expect(page).to have_field('Banheiro')
      expect(page).to have_field('Varanda')
      expect(page).to have_field('Ar-condicionado')
      expect(page).to have_field('TV')
      expect(page).to have_field('Guarda-roupas')
      expect(page).to have_field('Cofre')
      expect(page).to have_field('Acessível')
      expect(page).to have_field('Disponível')
      expect(page).to have_button('Atualizar Quarto')
    end

    it 'com sucesso' do
      # Arrange
      @owner = make_owner
      @inn = make_inn(@owner)
      @room = make_room(@inn)
      login_as(@owner)
      visit root_path
      click_on 'Minha Pousada'
      # Act
      first('button', text: 'Editar Quarto').click
      fill_in 'Descrição', with: 'Quarto presidencial, suíte limpinha e cheirosa.'
      check 'Ar-condicionado'
      click_on 'Atualizar Quarto'
      # Assert]
      expect(current_path).to eq(room_path(@room.id))
      expect(page).to have_content("#{@room.name} foi atualizado com sucesso!")
    end

    it 'e falha por validação' do
      # Arrange
      @owner = make_owner
      @inn = make_inn(@owner)
      @room = make_room(@inn)
      visit root_path
      login(@owner)
      click_on 'Minha Pousada'
      # Act
      first('button', text: 'Editar Quarto').click
      fill_in 'Nome', with: 'Outro nome de Quarto'
      fill_in 'Preço Base', with: ''
      click_on 'Atualizar Quarto'
      # Assert]
      expect(current_path).to eq(room_path(@room.id))
      expect(page).to have_content 'Não foi possível atualizar o quarto.'
    end
  end

  context 'a partir da página de Quarto' do
    it 'clicando em Editar Quarto' do
      # Arrange
      @owner = make_owner
      @inn = make_inn(@owner)
      @room = make_room(@inn)
      visit root_path
      login(@owner)
      click_on 'Minha Pousada'
      # Act
      click_on @room.name
      click_on 'Editar Quarto'
      # Assert
      expect(page).to have_field('Nome')
      expect(page).to have_field('Descrição')
      expect(page).to have_field('Área (m²)')
      expect(page).to have_field('Hóspedes')
      expect(page).to have_field('Preço Base')
      expect(page).to have_field('Banheiro')
      expect(page).to have_field('Varanda')
      expect(page).to have_field('Ar-condicionado')
      expect(page).to have_field('TV')
      expect(page).to have_field('Guarda-roupas')
      expect(page).to have_field('Cofre')
      expect(page).to have_field('Acessível')
      expect(page).to have_field('Disponível')
      expect(page).to have_button('Atualizar Quarto')
    end

    it 'com sucesso' do
      # Arrange
      @owner = make_owner
      @inn = make_inn(@owner)
      @room = make_room(@inn)
      visit root_path
      login(@owner)
      click_on 'Minha Pousada'
      # Act
      click_on @room.name
      click_on 'Editar Quarto'
      fill_in 'Descrição', with: 'Quarto presidencial, suíte limpinha e cheirosa.'
      check 'Ar-condicionado'
      click_on 'Atualizar Quarto'
      # Assert]
      expect(current_path).to eq(room_path(@room.id))
      expect(page).to have_content "#{@room.name} foi atualizado com sucesso!"
    end

    it 'e falha por validação' do
      # Arrange
      @owner = make_owner
      @inn = make_inn(@owner)
      @room = make_room(@inn)
      visit root_path
      login(@owner)
      click_on 'Minha Pousada'
      # Act
      click_on @room.name
      click_on 'Editar Quarto'
      fill_in 'Nome', with: 'Outro nome de Quarto'
      fill_in 'Preço Base', with: ''
      click_on 'Atualizar Quarto'
      # Assert]
      expect(current_path).to eq(room_path(@room.id))
      expect(page).to have_content 'Não foi possível atualizar o quarto.'
    end
  end
end
