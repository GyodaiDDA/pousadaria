require 'rails_helper'

describe '::Customer clica no botão Minhas Reservas' do
  it 'e visualiza lista de reservations com status' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer = make_customer('cpf')
    @reservation1 = make_customer_reservation(@room, @customer, nil, 3)
    @reservation2 = make_customer_reservation(@room, @customer, nil, 1)
    # Act
    visit root_path
    login(@customer)
    click_button 'Minhas Reservas'
    # Assert
    expect(current_path).to eq(reservations_list_path)
    expect(page).to have_content(@inn.brand_name)
    expect(page).to have_content("#{@inn.city}/#{@inn.state}")
    expect(page).to have_content(@reservation1.code)
    expect(page).to have_content("#{I18n.localize(@reservation1.start_date)} a #{I18n.localize(@reservation1.end_date)}")
    expect(page).to have_content(Reservation.l_enum(@reservation1.status))
    expect(page).to have_content(@reservation2.code)
    expect(page).to have_content("#{I18n.localize(@reservation2.start_date)} a #{I18n.localize(@reservation2.end_date)}")
    expect(page).to have_content(Reservation.l_enum(@reservation2.status))
  end

  it 'e acessa uma das reservations' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer = make_customer('cpf')
    make_customer_reservation(@room, @customer, nil, 1)
    make_customer_reservation(@room, @customer, nil, 1)
    @reservation = make_customer_reservation(@room, @customer, nil, 1)
    @reservation.update(status: 'confirmed')
    # Act
    visit root_path
    login(@customer)
    click_button 'Minhas Reservas'
    click_on @reservation.code
    # Assert
    expect(page).to have_content(@inn.brand_name)
    expect(page).to have_content(@room.name)
    expect(page).to have_content(@reservation.code)
    expect(current_path).to eq(room_reservation_path(@reservation.room, @reservation))
    expect(page).to have_button('Cancelar Reserva')
  end

  it 'e cancela a reservation com sucesso' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer = make_customer('cpf')
    make_customer_reservation(@room, @customer, nil, 1)
    make_customer_reservation(@room, @customer, nil, 1)
    @reservation = make_customer_reservation(@room, @customer, nil, 1)
    @reservation.update(status: 'confirmed')
    # Act
    visit root_path
    login(@customer)
    click_button 'Minhas Reservas'
    click_on @reservation.code
    click_on 'Cancelar Reserva'
    # Assert
    expect(page).to have_content('Poxa, que pena que teve que cancelar.')
  end
end
