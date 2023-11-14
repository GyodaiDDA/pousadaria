require 'rails_helper'
require 'support/fake'

describe '::Owner visualiza detalhes de uma pousada' do
  before(:each) do
    @owner = make_owner
    @inn = make_inn(@owner)
    make_rooms(@inn, 4)
  end

  it 'que é a sua' do
    # Arrange
    login_as(@owner)
    # Act
    visit root_path
    click_on 'Minha Pousada'
    # Assert
    expect(current_path).to eq(inn_path(@inn.id))
    expect(page).to have_content(@inn.brand_name)
    expect(page).to have_button('Editar Pousada')
    expect(page).to have_button('Adicionar Quarto')
  end

  it 'que não é sua' do
    # Arrange
    @another_owner = make_owner
    @another_inn = make_inn(@another_owner)
    login_as(@another_owner)
    # Act
    visit root_path
    click_on 'Home'
    click_on(@inn.brand_name)
    # click_on(@room.name)
    # Assert
    expect(page).to have_content(@inn.brand_name)
    expect(page).not_to have_button('Editar Pousada')
    expect(page).not_to have_button('Adicionar Quarto')
  end
end
