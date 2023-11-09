require 'rails_helper'

describe '::Visitante vê a página da Pousada' do
  before(:each) do
    owner = Owner.create!(email: 'usuario@servidor.co.uk',
                          password: '.SenhaSuper3',
                          user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Recanto do Sossego',
                      legal_name: 'Recanto do Sossego Hospedagens LTDA',
                      vat_number: '12345678000911',
                      postal_code: '13200-000',
                      city: 'Arruaces',
                      state: 'AC',
                      active: true,
                      user_id: owner.id)
    room = Room.create!(name: 'Quarto Orlindgans',
                        size: 30,
                        max_guests: 2,
                        base_price: 300,
                        tv: true,
                        safe: true,
                        inn_id: inn.id,
                        available: true)
    Room.create!(name: 'Quarto Cardiganson',
                 size: 40,
                 max_guests: 3,
                 base_price: 200,
                 inn_id: inn.id,
                 available: false)
    Seasonal.create!(name: 'Feriação do Faustão',
                     start_date: '2024-01-01',
                     end_date: '2024-01-31',
                     special_price: 340,
                     room_id: room.id)
    visit root_path
  end

  it 'com lista de quartos ativos' do
    # Arrange
    # Act
    click_on 'Pousada Recanto do Sossego'
    # Assert
    expect(current_path).to eq(inn_path('1'))
    expect(page).to have_content('Pousada Recanto do Sossego')
    expect(page).to have_content('Quarto Orlindgans')
    expect(page).to have_content('30m²')
    expect(page).to have_content('R$ 300')
    expect(page).to have_content('TV')
    expect(page).to have_content('Cofre')
    expect(page).not_to have_content('Quarto Cardiganson')
  end
end
