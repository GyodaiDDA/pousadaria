require 'rails_helper'

describe '::Usuário clica em Busca Avançada' do
  before(:each) do
    4.times do
      @owner = make_owner
      @inn = make_inn(@owner)
    end
    @customer = make_customer
    login_as(@customer)
  end

  it 'e vê o formulário de busca' do
    # Arrange
    # Act
    visit root_path
    click_on 'Busca Avançada'
    # Assert
    expect(page).to have_content('Busca Avançada')
    expect(page).to have_field('Nome')
    expect(page).to have_field('Cidade')
    expect(page).to have_field('UF')
  end
end