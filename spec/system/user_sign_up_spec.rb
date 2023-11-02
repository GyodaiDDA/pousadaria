require 'rails_helper'

describe '::Usuário faz sign up' do
  before(:each) do
    visit root_path
    click_on 'Cadastre-se'
  end
  it 'pelo botão Cadastre-se na home' do
    # Arrange
    # Act
    # Assert
    expect(current_path).to eq(new_user_registration_path)
    expect(page).to have_content('E-mail')
    expect(page).to have_content('Senha')
    expect(page).to have_content('Confirme sua senha')
    expect(page).to have_button('Cadastre-se')
  end

  it 'com sucesso' do
    # Arrange
    # Act
    fill_in 'E-mail', with: 'usuario@servidor.co.uk'
    fill_in 'Senha', with: 'SenhaSuper!9'
    fill_in 'Confirme sua senha', with: 'SenhaSuper!9'
    click_on 'Cadastre-se'
    # Assert
    expect(current_path).to eq(root_path)
    expect(page).to have_content('Boas vindas! Você realizou seu registro com sucesso.')
  end

  it 'sem sucesso - confirmação falha de senha' do
    # Arrange
    # Act
    fill_in 'E-mail', with: 'usuario@servidor.com.uk'
    fill_in 'Senha', with: 'SenhaSuper!9'
    fill_in 'Confirme sua senha', with: 'SenhaSuper9'
    click_on 'Cadastre-se'
    # Assert
    expect(current_path).to eq(user_registration_path)
  end

  it 'sem sucesso - email fora do padrão' do
    # Arrange
    # Act
    fill_in 'E-mail', with: 'usuario@servidor.co.uk'
    fill_in 'Senha', with: 'SenhaSuper!9'
    fill_in 'Confirme sua senha', with: 'SenhaSuper!9'
    click_on 'Cadastre-se'
    click_on 'Cadastre-se'if expect(page).to have_content('Boas vindas!')
    # Assert
    expect(current_path).to eq(root_path)
    expect(page).to have_content('Você já está auten')
  end
end
