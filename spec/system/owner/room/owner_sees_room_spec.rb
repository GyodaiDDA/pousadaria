require 'rails_helper'
require 'support/fake'

describe '::Owner visualiza detalhes de um quarto' do
  before(:each) do
    @owner = make_owner
    @inn = make_inn(@owner)
    make_rooms(@inn)
    @room = @inn.rooms.first
  end

  it 'da sua pousada' do
    # Arrange
    login_as(@owner)
    # Act
    visit root_path
    click_on 'Minha Pousada'
    click_on @room.name
    # Assert
    expect(current_path).to eq(room_path(@room.id))
    expect(page).to have_content(@room.name)
    expect(page).to have_button('Editar Quarto')
    expect(page).to have_button('Adicionar Período Especial')
  end

  it 'de outra pousada' do
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
    expect(page).to have_content(@room.name)
    expect(page).not_to have_button('Editar Quarto')
    expect(page).not_to have_button('Adicionar Período Especial')
  end
end
