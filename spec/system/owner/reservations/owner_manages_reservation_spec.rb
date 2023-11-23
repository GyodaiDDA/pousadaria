require 'rails_helper'

describe '::Owner acessa uma reserva' do
  it 'clicando no código em Reservas' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer1 = make_customer('cpf')
    @reservation1 = Reservation.new(room_id: @room.id,
                                    user_id: @customer1.id,
                                    start_date: Time.zone.yesterday,
                                    end_date: Time.zone.tomorrow,
                                    guests: 1,
                                    status: 'confirmed')
    @reservation1.save(validate: false)
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
    expect(page).to have_content('Status: Disponível')
  end

  it 'e cancela a reserva' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer1 = make_customer('cpf')
    @reservation1 = Reservation.new(room_id: @room.id,
                                    user_id: @customer1.id,
                                    start_date: Time.zone.yesterday - 2.days,
                                    end_date: Time.zone.tomorrow,
                                    guests: 1)
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
    @customer1 = make_customer('cpf')
    @reservation1 = Reservation.new(room_id: @room.id,
                                    user_id: @customer1.id,
                                    start_date: Time.zone.yesterday - 2.days,
                                    end_date: Time.zone.tomorrow,
                                    guests: 1)
    @reservation1.save(validate: false)
    @reservation1.status = 'active'
    @reservation1.save(validate: false)
    # Act
    visit root_path
    login(@owner)
    click_on 'Reservas'
    click_on @reservation1.code
    click_on 'Iniciar check-out'
    # Assert
    expect(current_path).to eq(room_reservation_path(@reservation1.room, @reservation1))
    expect(page).to have_content('Preparando check-out')
    expect(page).to have_content("Valor a pagar: #{@reservation1.total_value}")
  end
end
