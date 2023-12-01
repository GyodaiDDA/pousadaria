require 'rails_helper'

describe '::Não-logado vê a página da Pousada' do
  it 'com lista de quartos ativos' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room1 = make_room(@inn, { tv: 1, safe: 1, available: 1 })
    @room2 = make_room(@inn, { available: 0 })
    @seasonal1 = make_seasonals(@room1)
    @seasonal2 = make_seasonals(@room2)
    visit root_path
    # Act
    click_on @inn.brand_name
    # Assert
    expect(current_path).to eq(inn_path(@room1.id))
    expect(page).to have_content(@room1.name)
    expect(page).to have_content(@room1.description)
    expect(page).not_to have_content(@room2.name)
    expect(page).not_to have_content(@seasonal1.name)
    expect(page).not_to have_content(@seasonal2.name)
  end
end
