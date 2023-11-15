require 'rails_helper'

describe '::Visitante vê a página da Pousada' do
  before(:each) do
    @owner = make_owner
    @inn = make_inn(@owner)
    make_rooms(@inn, 1, { tv: 1, safe: 1, available: 1 })
    make_rooms(@inn, 1, { available: 0 })
    @first_room = @inn.rooms.first
    @last_room = @inn.rooms.last
    @seasonal = make_seasonals(@first_room)
    @seasonal = make_seasonals(@last_room)
    visit root_path
  end

  it 'com lista de quartos ativos' do
    # Arrange
    # Act
    click_on @inn.brand_name
    # Assert
    expect(current_path).to eq(inn_path(@first_room.id))
    expect(page).to have_content(@first_room.name)
    expect(page).to have_content(@first_room.description)
    expect(page).not_to have_content(@last_room.name)
  end
end
