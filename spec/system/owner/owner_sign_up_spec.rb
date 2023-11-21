require 'rails_helper'

describe '::Usuário cria uma nova conta' do
  it 'mas falha na confirmação de senha' do
    # Arrange
    visit root_path
    click_on 'Entrar'
    click_on 'Ainda não tem cadastro?'
    click_on 'Quero me hospedar'
    # Act
    fill_in 'E-mail', with: 'usuario@servidor.co.uk'
    fill_in 'Senha', with: '.SenhaSuper3'
    fill_in 'Confirme sua senha', with: '.SenhaSuper6'
    click_on 'Cadastre-se'
    # Assert
    expect(current_path).to eq(user_registration_path)
    expect(page).to have_content('Confirme sua senha não é igual a Senha')
  end

  it 'mas email já está em uso como Owner' do
    # Arrange
    visit root_path
    click_on 'Entrar'
    click_on 'Ainda não tem cadastro?'
    User.create!(email: 'usuario@servidor.co.uk',
                 password: '123456',
                 user_type: 'Owner')
    # Act
    click_on 'Quero me hospedar'
    fill_in 'E-mail', with: 'usuario@servidor.co.uk'
    fill_in 'Senha', with: '.SenhaSuper3'
    fill_in 'Confirme sua senha', with: '.SenhaSuper3'
    click_on 'Cadastre-se'
    # Assert
    expect(current_path).to eq(user_registration_path)
    expect(page).to have_content('E-mail já está em uso')
  end

  it 'mas email já está em uso como Customer' do
    # Arrange
    visit root_path
    click_on 'Entrar'
    click_on 'Ainda não tem cadastro?'
    User.create!(email: 'usuario@servidor.co.uk',
                 password: '123456',
                 user_type: 'Customer')
    # Act
    click_on 'Sou dono de Pousada'
    fill_in 'E-mail', with: 'usuario@servidor.co.uk'
    fill_in 'Senha', with: '.SenhaSuper3'
    fill_in 'Confirme sua senha', with: '.SenhaSuper3'
    click_on 'Cadastre-se'
    # Assert
    expect(current_path).to eq(user_registration_path)
    expect(page).to have_content('E-mail já está em uso')
  end

  it 'com sucesso e é levado para criar a pousada' do
    # Arrange
    visit root_path
    click_on 'Entrar'
    click_on 'Ainda não tem cadastro?'
    click_on 'Sou dono de Pousada'
    # Act
    fill_in 'E-mail', with: 'usuario@servidor.co.uk'
    fill_in 'Senha', with: '.SenhaSuper3'
    fill_in 'Confirme sua senha', with: '.SenhaSuper3'
    click_on 'Cadastre-se'
    # Assert
    expect(current_path).to eq(new_inn_path)
    expect(page).to have_content('Boas vindas!')
    user = User.find_by(email: 'usuario@servidor.co.uk')
    expect(user).to be_present
    expect(user.user_type).to eq('Owner')
  end
end
