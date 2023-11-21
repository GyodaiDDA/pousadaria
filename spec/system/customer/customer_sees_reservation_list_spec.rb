require 'rails_helper'

describe '::Customer clica no botão Minhas Reservas' do
  it 'e visualiza lista de reservas com status' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer = make_customer('cpf')
    @reserva_confirmada = make_customer_reservation(@room, @customer, 3)
    @reserva_disponivel = make_customer_reservation(@room, @customer, 1)
    # Act
    visit root_path
    login(@customer)
    click_button 'Minhas Reservas'
    # Assert
    expect(page).to have_content(@inn.brand_name)
    expect(page).to have_content("#{@inn.city}/#{@inn.state}")
    expect(page).to have_content(@reserva_confirmada.code)
    expect(page).to have_content("#{I18n.localize(@reserva_confirmada.start_date)} a #{I18n.localize(@reserva_confirmada.end_date)}")
    expect(page).to have_content(@reserva_confirmada.status)
    expect(page).to have_content(@reserva_disponivel.code)
    expect(page).to have_content("#{I18n.localize(@reserva_disponivel.start_date)} a #{I18n.localize(@reserva_disponivel.end_date)}")
    expect(page).to have_content(@reserva_disponivel.status)
  end

  it 'e acessa uma das reservas' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer = make_customer('cpf')
    @reserva_confirmada = make_customer_reservation(@room, @customer, 3)
    @reserva_disponivel = make_customer_reservation(@room, @customer, 1)
    # Act
    visit root_path
    login(@customer)
    click_button 'Minhas Reservas'
    click_on @reserva_confirmada.code
    # Assert
    expect(page).to have_content(@inn.brand_name)
    expect(page).to have_content(@room.name)
    expect(page).to have_content(@reserva_confirmada.code)
    expect(page).to have_button('Cancelar Reserva')
  end

  it 'e cancela a reserva com sucesso' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer = make_customer('cpf')
    @reserva_confirmada = make_customer_reservation(@room, @customer, 3)
    @reserva_disponivel = make_customer_reservation(@room, @customer, 1)
    # Act
    visit root_path
    login(@customer)
    click_button 'Minhas Reservas'
    click_on @reserva_confirmada.code
    click_on 'Cancelar Reserva'
    # Assert
    expect(page).to have_content('Poxa, que pena que teve que cancelar.')
  end
end
