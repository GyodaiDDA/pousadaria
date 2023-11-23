require 'rails_helper'

describe '::Owner clica em Reservas' do
  it 'e vê lista de reservas' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer1 = make_customer('cpf')
    @reservation1 = make_customer_reservation(@room, @customer1)
    @customer2 = make_customer('cpf')
    @reservation2 = make_customer_reservation(@room, @customer2)
    @customer3 = make_customer('cpf')
    @reservation3 = make_customer_reservation(@room, @customer3)
    @reservation1.update(status: 'confirmed')
    # Act
    visit root_path
    login(@owner)
    click_on 'Reservas'
    # Assert
    expect(page).to have_content(@reservation1.room.name)
    expect(page).to have_content(@reservation2.room.name)
    expect(page).to have_content(@reservation3.room.name)
    expect(page).to have_content(I18n.localize(@reservation1.start_date))
    expect(page).to have_content(I18n.localize(@reservation2.start_date))
    expect(page).to have_content(I18n.localize(@reservation3.start_date))
    expect(page).to have_content(I18n.localize(@reservation1.end_date))
    expect(page).to have_content(I18n.localize(@reservation2.end_date))
    expect(page).to have_content(I18n.localize(@reservation3.end_date))
    expect(page).to have_content(@reservation1.guests)
    expect(page).to have_content(@reservation2.guests)
    expect(page).to have_content(@reservation3.guests)
    expect(page).to have_content(@reservation1.code)
    expect(page).to have_content(@reservation2.code)
    expect(page).to have_content(@reservation3.code)
    expect(page).to have_content(Reservation.l_enum(@reservation1.status))
    expect(page).to have_content(Reservation.l_enum(@reservation2.status))
    expect(page).to have_content(Reservation.l_enum(@reservation3.status))
  end
end
