require 'rails_helper'

describe '::Owner visualiza detalhes' do
  it 'da sua pousada' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    visit root_path
    login(@owner)
    # Act
    visit root_path
    click_on 'Minha Pousada'
    # Assert
    expect(current_path).to eq(inn_path(@inn.id))
    expect(page).to have_content(@inn.brand_name)
    expect(page).to have_button('Editar Pousada')
    expect(page).to have_button('Adicionar Quarto')
  end

  it 'da pousada de outrem' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @another_owner = make_owner
    @another_inn = make_inn(@another_owner)
    visit root_path
    login(@another_owner)
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
