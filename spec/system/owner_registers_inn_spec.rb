require 'rails_helper'

describe '::Dono de Pousada completa o cadastro' do
  it 'incluindo a pousada' do
    # Arrange
    owner = Owner.create(email: 'usuario@servidor.co.uk', password: '.SenhaSuper3', type: 'Owner')
    # Act
    login_as(owner)
    visit root_path
    # click_on 'cadastrar a sua pousada'
    # Assert
    expect(page).to have_field('Nome Fantasia')
    expect(page).to have_field('Descrição')
    expect(page).to have_field('Endereço')
    expect(page).to have_field('CEP')
    expect(page).to have_field('Cidade')
    expect(page).to have_field('Estado')
    expect(page).to have_field('Check In')
    expect(page).to have_field('Check Out')
  end
end
