require 'rails_helper'

describe '::Usuário faz sign in' do
  before(:each) do
    User.create!(email: 'usuario@servidor.co.uk',
                 password: 'SenhaSuper!9')
    visit root_path
    click_on 'Entrar'
  end
  it 'pelo botão Entrar na home' do
    # Arrange
    # Act
    # Assert
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content('E-mail')
    expect(page).to have_content('Senha')
    expect(page).to have_content('Lembre-se de mim')
    expect(page).to have_button('Entrar')
  end

  it 'com sucesso' do
    # Arrange
    # Act
    fill_in 'E-mail', with: 'usuario@servidor.co.uk'
    fill_in 'Senha', with: 'SenhaSuper!9'
    click_on 'Entrar'
    # Assert
    expect(current_path).to eq(root_path)
    expect(page).to have_content('Olá! Seu login foi feito com sucesso.')
  end

  it 'sem sucesso - dados inválidos' do
    # Arrange
    # Act
    fill_in 'E-mail', with: 'usuario@servidor.com'
    fill_in 'Senha', with: 'SenhaSuper!9'
    click_on 'Entrar'
    # Assert
    expect(page).to have_content('E-mail ou senha inválidos.')
    expect(current_path).to eq(user_session_path)
  end
end
