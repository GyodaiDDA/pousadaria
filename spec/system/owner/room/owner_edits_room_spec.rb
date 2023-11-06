require 'rails_helper'

describe '::Owner altera Quarto' do
  context 'a partir da página de Pousada' do
    before(:each) do
      owner = Owner.create(email: 'usuario@servidor.co.uk',
                           password: '.SenhaSuper3',
                           type: 'Owner')
      inn = Inn.create(brand_name: 'Pousada Recanto do Sossego',
                       legal_name: 'Recanto do Sossego Hospedagens LTDA',
                       vat_number: '12345678000911',
                       postal_code: '13200-000',
                       user_id: owner.id)
      Room.create(name: 'Quarto Orlindgans', size: 30, max_guests: 2,
                  base_price: 300, inn_id: inn.id)
      login_as(owner)
      visit root_path
      click_on 'Minha Pousada'
    end

    it 'clicando em Editar' do
      # Arrange
      # Act
      within 'div#rooms_list' do
        click_on 'Editar'
      end
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
      # Act
      within 'div#rooms_list' do
        click_on 'Editar'
      end
      fill_in 'Descrição', with: 'Quarto presidencial, suíte limpinha e cheirosa.'
      check 'Ar-condicionado'
      click_on 'Atualizar Quarto'
      # Assert]
      expect(current_path).to eq(room_path(1))
      expect(page).to have_content 'Quarto Orlindgans foi atualizado com sucesso!'
    end

    it 'e falha por validação' do
      # Arrange
      # Act
      within 'div#rooms_list' do
        click_on 'Editar'
      end
      fill_in 'Nome', with: 'Outro nome de Quarto'
      fill_in 'Preço Base', with: ''
      click_on 'Atualizar Quarto'
      # Assert]
      expect(current_path).to eq(room_path(1))
      expect(page).to have_content 'Não foi possível atualizar o quarto.'
    end
  end

  context 'a partir da página de Quarto' do
    before(:each) do
      owner = Owner.create(email: 'usuario@servidor.co.uk',
                           password: '.SenhaSuper3',
                           type: 'Owner')
      inn = Inn.create(brand_name: 'Pousada Recanto do Sossego',
                       legal_name: 'Recanto do Sossego Hospedagens LTDA',
                       vat_number: '12345678000911',
                       postal_code: '13200-000',
                       user_id: owner.id)
      Room.create(name: 'Quarto Orlindgans', size: 30, max_guests: 2,
                  base_price: 300, inn_id: inn.id)
      login_as(owner)
      visit root_path
      click_on 'Minha Pousada'
    end

    it 'clicando em Editar Quarto' do
      # Arrange
      # Act
      within 'div#rooms_list' do
        click_on 'Ver'
      end
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
      # Act
      within 'div#rooms_list' do
        click_on 'Ver'
      end
      click_on 'Editar Quarto'
      fill_in 'Descrição', with: 'Quarto presidencial, suíte limpinha e cheirosa.'
      check 'Ar-condicionado'
      click_on 'Atualizar Quarto'
      # Assert]
      expect(current_path).to eq(room_path(1))
      expect(page).to have_content 'Quarto Orlindgans foi atualizado com sucesso!'
    end

    it 'e falha por validação' do
      # Arrange
      # Act
      within 'div#rooms_list' do
        click_on 'Ver'
      end
      click_on 'Editar Quarto'
      fill_in 'Nome', with: 'Outro nome de Quarto'
      fill_in 'Preço Base', with: ''
      click_on 'Atualizar Quarto'
      # Assert]
      expect(current_path).to eq(room_path(1))
      expect(page).to have_content 'Não foi possível atualizar o quarto.'
    end
  end
end
