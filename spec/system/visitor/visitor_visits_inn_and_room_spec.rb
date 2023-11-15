require 'rails_helper'

describe '::Visitante vê a página da Pousada' do
  before(:each) do
    @owner = make_owner
    @inn = make_inn(@owner)
    make_rooms(@inn, 1, { tv: 1, safe: 1, available: 1 })
    make_rooms(@inn, 1, { available: 0 })
    @first_room = @inn.rooms.first
    @last_room = @inn.rooms.last
<<<<<<< HEAD
    Seasonal.create!(name: 'Feriadão do Faustão',
                     start_date: '2024-01-01',
                     end_date: '2024-01-31',
                     special_price: 340,
                     room_id: @first_room.id)
=======
    @seasonal = make_seasonals(@first_room)
    @seasonal = make_seasonals(@last_room)
>>>>>>> bootstrap
    visit root_path
  end

  it 'com lista de quartos ativos' do
    # Arrange
    # Act
<<<<<<< HEAD
    click_link(@inn.brand_name)
    # Assert
    expect(current_path).to eq(inn_path(@inn.id))
    expect(page).to have_content(@inn.brand_name)
    expect(page).to have_content(@first_room.name)
    expect(page).to have_content(@first_room.size)
    expect(page).to have_content(@first_room.base_price)
    expect(page).to have_content('TV')
    expect(page).to have_content('Cofre')
=======
    click_on @inn.brand_name
    # Assert
    expect(current_path).to eq(inn_path(@first_room.id))
    expect(page).to have_content(@first_room.name)
    expect(page).to have_content(@first_room.description)
>>>>>>> bootstrap
    expect(page).not_to have_content(@last_room.name)
  end
end
