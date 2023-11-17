require 'rails_helper'

describe '::Owner clica no botão Entrar' do
  it 'e vê a página de login' do
    # Arrange
    @owner = make_owner
    # Act
    visit root_path
    click_on 'Entrar'
    # Assert
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content('E-mail')
    expect(page).to have_content('Senha')
    expect(page).to have_content('Lembre-se de mim')
    expect(page).to have_button('Entrar')
  end

  it 'e falha ao fazer login' do
    # Arrange
    @owner = make_owner
    # Act
    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: @owner.email
    fill_in 'Senha', with: 'passavord'
    within('div.actions') do
      click_on 'Entrar'
    end
    # Assert
    expect(page).to have_content('E-mail ou senha inválidos.')
  end

  context 'e faz login com sucesso' do
    it 'tendo pousada' do
      # Arrange
      @owner = make_owner
      @inn = make_inn(@owner)
      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: @owner.email
      fill_in 'Senha', with: @owner.password
      within('div.actions') do
        click_on 'Entrar'
      end
      # Assert
      expect(current_path).to eq(inn_path(@inn.id))
      expect(page).to have_content('Olá! Seu login foi feito com sucesso.')
      expect(page).to have_content(@inn.brand_name)
    end

    it 'sem ter pousada' do
      # Arrange
      @owner = make_owner
      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: @owner.email
      fill_in 'Senha', with: @owner.password
      within('div.actions') do
        click_on 'Entrar'
      end
      # Assert
      expect(current_path).to eq(new_inn_path)
    end
  end
end
