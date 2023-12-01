require 'rails_helper'
require 'active_support/testing/time_helpers'

describe '::Owner acessa uma reserva' do
  it 'clicando no código em Reservas' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer = make_customer('cpf')
    travel_to Time.zone.now - 10.days
    @reservation = Reservation.create!(room_id: @room.id,
                                        user_id: @customer.id,
                                        start_date: Time.zone.tomorrow,
                                        end_date: Time.zone.tomorrow + 10.days,
                                        guests: 1)
    # Act
    visit root_path
    login(@owner)
    click_on 'Reservas'
    click_on @reservation.code
    # Assert
    expect(current_path).to eq(room_reservation_path(@reservation.room, @reservation))
    expect(page).to have_content(@reservation.room.name)
    expect(page).to have_content(@customer.full_name)
    expect(page).to have_content(@reservation.code)
    expect(page).to have_content(I18n.localize(@reservation.start_date))
    expect(page).to have_content(I18n.localize(@reservation.end_date))
    expect(page).to have_content(Reservation.l_enum(@reservation.status))
  end

  it 'e cancela a reserva' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer = make_customer('cpf')
    @reservation = Reservation.new(room_id: @room.id,
                                    user_id: @customer.id,
                                    start_date: Time.zone.tomorrow,
                                    end_date: Time.zone.tomorrow + 10.days,
                                    guests: 1)
    @reservation.save(validate: false)
    @reservation.start_date = Time.zone.now - 3.days
    @reservation.status = 'confirmed'
    @reservation.save(validate: false)
    # Act
    visit root_path
    login(@owner)
    click_on 'Reservas'
    click_on @reservation.code
    click_on 'Cancelar reserva'
    # Assert
    expect(current_path).to eq(room_reservation_path(@reservation.room, @reservation))
    expect(page).to have_content('Status: Cancelada')
  end

  it 'e registra os hóspedes' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer = make_customer('cpf')
    @reservation = Reservation.new(room_id: @room.id,
                                    user_id: @customer.id,
                                    start_date: Time.zone.yesterday - 1.day,
                                    end_date: Time.zone.tomorrow,
                                    guests: 1)
    @reservation.save(validate: false)
    @reservation.status = 'confirmed'
    @reservation.save(validate: false)
    # Act
    visit root_path
    login(@owner)
    click_on 'Reservas'
    click_on @reservation.code
    fill_in 'Nome Completo', with: 'César Nunes Menezes de Pádua'
    fill_in 'CPF ou RG', with: '12345678988'
    fill_in 'E-mail', with: @customer.email
    click_on 'Registrar'
    # Assert
    expect(current_path).to eq(room_reservation_path(@reservation.room, @reservation))
    expect(page).to have_content('Status: Pronto para Check-in')
  end

  it 'e faz check-in' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer = make_customer('cpf')
    @reservation = Reservation.new(room_id: @room.id,
                                    user_id: @customer.id,
                                    start_date: Time.zone.yesterday - 1.day,
                                    end_date: Time.zone.tomorrow,
                                    guests: 1)
    @reservation.save(validate: false)
    @reservation.status = 'confirmed'
    @reservation.save(validate: false)
    # Act
    visit root_path
    login(@owner)
    click_on 'Reservas'
    click_on @reservation.code
    fill_in 'Nome Completo', with: 'César Nunes Menezes de Pádua'
    fill_in 'CPF ou RG', with: '12345678988'
    fill_in 'E-mail', with: @customer.email
    click_on 'Registrar'
    click_on 'Fazer check-in'
    # Assert
    expect(current_path).to eq(room_reservation_path(@reservation.room, @reservation))
    expect(page).to have_content('Status: Ativa')
    expect(page).to have_content("Check-in Efetivo: #{I18n.localize(Date.today)}")
  end

  it 'e prepara o check-out' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer = make_customer('cpf')
    @reservation = Reservation.new(room_id: @room.id,
                                   user_id: @customer.id,
                                   start_date: Time.zone.yesterday - 1.day,
                                   end_date: Time.zone.tomorrow,
                                   guests: 1)
    @reservation.save(validate: false)
    @reservation.status = 'confirmed'
    @reservation.save(validate: false)
    # Act
    visit root_path
    login(@owner)
    click_on 'Reservas'
    click_on @reservation.code
    fill_in 'Nome Completo', with: 'César Nunes Menezes de Pádua'
    fill_in 'CPF ou RG', with: '12345678988'
    fill_in 'E-mail', with: @customer.email
    click_on 'Registrar'
    click_on 'Fazer check-in'
    travel 5.days
    click_on 'Iniciar check-out'
    # Assert
    expect(current_path).to eq(room_reservation_path(@reservation.room, @reservation))
    expect(page).to have_content('Preparando check-out')
    expect(page).to have_content("Valor final: #{@reservation.total_value}")
  end

  it 'e conclui o check-out' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer = make_customer('cpf')
    @reservation = Reservation.new(room_id: @room.id,
                                   user_id: @customer.id,
                                   start_date: Time.zone.yesterday - 1.day,
                                   end_date: Time.zone.tomorrow,
                                   guests: 1)
    @reservation.save(validate: false)
    @reservation.status = 'confirmed'
    @reservation.save(validate: false)
    # Act
    visit root_path
    login(@owner)
    click_on 'Reservas'
    click_on @reservation.code
    fill_in 'Nome Completo', with: 'César Nunes Menezes de Pádua'
    fill_in 'CPF ou RG', with: '12345678988'
    fill_in 'E-mail', with: @customer.email
    click_on 'Registrar'
    click_on 'Fazer check-in'
    travel 5.days
    click_on 'Iniciar check-out'
    click_on 'Finalizar'
    # Assert
    expect(current_path).to eq(room_reservation_path(@reservation.room, @reservation))
    expect(page).to have_content('Concluída')
    expect(page).to have_content("Valor final: #{@reservation.total_value}")
    expect(page).to have_content("Forma de pagto: #{@reservation.payment}")
  end
end
