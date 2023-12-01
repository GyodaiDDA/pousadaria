require 'rails_helper'

describe '::Owner vê quarto' do
  it 'da sua pousada, com acesso para editar' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    visit root_path
    login(@owner)
    # Act
    click_on 'Minha Pousada'
    click_on @room.name
    # Assert
    expect(current_path).to eq(room_path(@room.id))
    expect(page).to have_content(@room.name)
    expect(page).to have_button('Editar Quarto')
    expect(page).to have_button('Adicionar Período Especial')
  end

  it 'de outra pousada, sem acesso para editar' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @another_owner = make_owner
    @another_inn = make_inn(@another_owner)
    visit root_path
    login(@another_owner)
    # Act
    click_on 'Home'
    click_on(@inn.brand_name)
    # click_on(@room.name)
    # Assert
    expect(page).to have_content(@room.name)
    expect(page).not_to have_button('Editar Quarto')
    expect(page).not_to have_button('Adicionar Período Especial')
  end
end
