require 'rails_helper'
require 'active_support/testing/time_helpers'

describe '::Owner acessa uma reserva' do
  it 'clicando no código em Reservas' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer1 = make_customer('cpf')
    travel_to Time.zone.now - 10.days
    @reservation1 = Reservation.create!(room_id: @room.id,
                                        user_id: @customer1.id,
                                        start_date: Time.zone.tomorrow,
                                        end_date: Time.zone.tomorrow + 10.days,
                                        guests: 1)
    # Act
    visit root_path
    login(@owner)
    click_on 'Reservas'
    click_on @reservation1.code
    # Assert
    expect(current_path).to eq(room_reservation_path(@reservation1.room, @reservation1))
    expect(page).to have_content(@reservation1.room.name)
    expect(page).to have_content(@customer1.full_name)
    expect(page).to have_content(@reservation1.code)
    expect(page).to have_content(I18n.localize(@reservation1.start_date))
    expect(page).to have_content(I18n.localize(@reservation1.end_date))
    expect(page).to have_content(Reservation.l_enum(@reservation1.status))
  end

  it 'e cancela a reserva' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer1 = make_customer('cpf')
    @reservation1 = Reservation.new(room_id: @room.id,
                                    user_id: @customer1.id,
                                    start_date: Time.zone.tomorrow,
                                    end_date: Time.zone.tomorrow + 10.days,
                                    guests: 1)
    @reservation1.save(validate: false)
    @reservation1.start_date = Time.zone.now - 3.days
    @reservation1.status = 'confirmed'
    @reservation1.save(validate: false)
    # Act
    visit root_path
    login(@owner)
    click_on 'Reservas'
    click_on @reservation1.code
    click_on 'Cancelar Reserva'
    # Assert
    expect(current_path).to eq(room_reservation_path(@reservation1.room, @reservation1))
    expect(page).to have_content('Status: Cancelada')
  end

  it 'e registra o check-in' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer1 = make_customer('cpf')
    @reservation1 = Reservation.new(room_id: @room.id,
                                    user_id: @customer1.id,
                                    start_date: Time.zone.yesterday - 1.day,
                                    end_date: Time.zone.tomorrow,
                                    guests: 1)
    @reservation1.save(validate: false)
    @reservation1.status = 'confirmed'
    @reservation1.save(validate: false)
    # Act
    visit root_path
    login(@owner)
    click_on 'Reservas'
    click_on @reservation1.code
    click_on 'Fazer check-in'
    # Assert
    expect(current_path).to eq(room_reservation_path(@reservation1.room, @reservation1))
    expect(page).to have_content('Status: Ativa')
  end

  it 'e prepara o check-out' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer = make_customer('cpf')
    @reservation = make_customer_reservation(@room, @customer, Time.zone.today + 2.days, 10.days)
    @reservation.update(status: 'confirmed')
    travel 3.days
    # Act
    visit root_path
    login(@owner)
    click_on 'Reservas'
    click_on @reservation.code
    click_on 'Fazer check-in'
    travel 5.days
    click_on 'Iniciar check-out'
    # Assert
    expect(current_path).to eq(room_reservation_path(@reservation.room, @reservation))
    expect(page).to have_content('Preparando check-out')
    expect(page).to have_content("Valor a pagar: #{@reservation.total_value}")
  end

  it 'e conclui o check-out' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer = make_customer('cpf')
    @reservation = make_customer_reservation(@room, @customer, Time.zone.today + 2.days, 10.days)
    @reservation.update(status: 'confirmed')
    travel 3.days
    # Act
    visit root_path
    login(@owner)
    click_on 'Reservas'
    click_on @reservation.code
    click_on 'Fazer check-in'
    travel 5.days
    visit current_path
    click_on 'Iniciar check-out'
    click_on 'Finalizar check-out'
    # Assert
    expect(current_path).to eq(room_reservation_path(@reservation.room, @reservation))
    expect(page).to have_content('Concluída')
    expect(page).to have_content("Valor pago: #{@reservation.total_value}")
    expect(page).to have_content("Forma de pagto: #{@reservation.payment}")
  end
end
