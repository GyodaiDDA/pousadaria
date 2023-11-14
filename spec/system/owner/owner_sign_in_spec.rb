require 'rails_helper'

describe '::Owner clica no botão Entrar' do
  before(:each) do
    @owner = make_owner
    visit root_path
    click_on 'Entrar'
  end

  it 'e vê a página de login' do
    # Arrange
    # Act
    # Assert
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content('E-mail')
    expect(page).to have_content('Senha')
    expect(page).to have_content('Lembre-se de mim')
    expect(page).to have_button('Entrar')
  end

  it 'e faz login com sucesso' do
    # Arrange
<<<<<<< Updated upstream
    Inn.create!(brand_name: 'Pousada Recanto do Sossego',
                legal_name: 'Recanto do Sossego Hospedagens LTDA',
                vat_number: '22333444000181',
                city: 'San Francisco',
                state: 'CA',
                postal_code: '13200-000',
                active: true,
                user_id: @owner.id)
=======
    @inn = make_inn(@owner)
>>>>>>> Stashed changes
    # Act
    fill_in 'E-mail', with: @owner.email
    fill_in 'Senha', with: @owner.password
    within('div.actions') do
      click_on 'Entrar'
    end
    # Assert
    expect(current_path).to eq(inn_path(1))
    expect(page).to have_content('Olá! Seu login foi feito com sucesso.')
    expect(page).to have_content(@inn.brand_name)
  end

  it 'e falha ao fazer login' do
    # Arrange
    # Act
    fill_in 'E-mail', with: 'usuario@servidor.com'
    fill_in 'Senha', with: '.SenhaSuper3'
    within('div.actions') do
      click_on 'Entrar'
    end
    # Assert
    expect(page).to have_content('E-mail ou senha inválidos.')
    expect(current_path).to eq(user_session_path) && eq(new_user_session_path)
  end

  it 'com sucesso e é levado para criar a pousada' do
    # Arrange
    # Act
    fill_in 'E-mail', with: @owner.email
    fill_in 'Senha', with: @owner.password
    within('div.actions') do
      click_on 'Entrar'
    end
    # Assert
    expect(current_path).to eq(new_inn_path)
  end
end
