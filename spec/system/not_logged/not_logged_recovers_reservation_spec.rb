require 'rails_helper'

describe '::quer fazer reserva' do
  it 'e faz consulta' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    # Act
    visit root_path
    click_on @inn.brand_name
    click_on @room.name
    click_on 'Quero reservar'
    fill_in 'Data de Entrada', with: Time.zone.today + 10.days
    fill_in 'Data de Saída', with: Time.zone.today + 13.days
    select rand(1..@room.max_guests).to_s, from: 'Hóspedes'
    click_button 'Fazer Reserva'
    # Assert
    expect(current_path).to eq(room_reservation_path(@room.id, Reservation.last.id))
    expect(page).to have_content('Legal! Quarto disponível para esta reserva.')
  end

  it 'e faz login pelo menu' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer = make_customer('CPF')
    # Act
    visit root_path
    click_on @inn.brand_name
    click_on @room.name
    click_on 'Quero reservar'
    fill_in 'Data de Entrada', with: Time.zone.today + 10.days
    fill_in 'Data de Saída', with: Time.zone.today + 13.days
    select rand(1..@room.max_guests).to_s, from: 'Hóspedes'
    click_button 'Fazer Reserva'
    click_on 'Home'
    click_on 'Entrar'
    fill_in 'E-mail', with: @customer.email
    fill_in 'Senha', with: @customer.password
    click_on 'Entrar'
    # Assert
    expect(current_path).to eq(reservations_retrieve_path)
    expect(page).to have_content('Gostaria de continuar com a sua reserva?')
    expect(page).to have_button('Continuar Reserva')
  end

  it 'e não tem CPF' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer = make_customer
    # Act
    visit root_path
    click_on @inn.brand_name
    click_on @room.name
    click_on 'Quero reservar'
    fill_in 'Data de Entrada', with: Time.zone.today + 10.days
    fill_in 'Data de Saída', with: Time.zone.today + 13.days
    select rand(1..@room.max_guests).to_s, from: 'Hóspedes'
    click_button 'Fazer Reserva'
    click_on 'Home'
    click_on 'Entrar'
    fill_in 'E-mail', with: @customer.email
    fill_in 'Senha', with: @customer.password
    click_on 'Entrar'
    click_on 'Continuar Reserva'
    fill_in 'Nome completo', with: 'Cesar Tralha'
    fill_in 'CPF', with: make_cpf
    fill_in 'Senha atual', with: @customer.password
    click_on 'Atualizar'
    # Assert
    expect(current_path).to eq(room_reservation_path(@room.id, Reservation.last.id))
    expect(page).to have_content('Seu cadastrado foi atualizado.')
    expect(page).to have_content("até as #{I18n.localize(Reservation.last.room.inn.check_in)}")
    expect(page).to have_content("até as #{I18n.localize(Reservation.last.room.inn.check_out)}")
    expect(page).to have_content("Check-in: #{I18n.localize(Reservation.last.start_date)}")
    expect(page).to have_content("Check-out: #{I18n.localize(Reservation.last.end_date)}")
    expect(page).to have_content("Acomodações: #{Reservation.last.room.name}")
    expect(page).to have_button('Confirmar Reserva')
  end

  it 'e finaliza a reserva' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer = make_customer('CPF')
    # Act
    visit root_path
    click_on @inn.brand_name
    click_on @room.name
    click_on 'Quero reservar'
    fill_in 'Data de Entrada', with: Time.zone.today + 10.days
    fill_in 'Data de Saída', with: Time.zone.today + 13.days
    select rand(1..@room.max_guests).to_s, from: 'Hóspedes'
    click_button 'Fazer Reserva'
    click_on 'Home'
    click_on 'Entrar'
    fill_in 'E-mail', with: @customer.email
    fill_in 'Senha', with: @customer.password
    click_on 'Entrar'
    click_on 'Continuar Reserva'
    click_on 'Confirmar Reserva'
    # Assert
    expect(current_path).to eq(room_reservation_path(@room.id, Reservation.last.id))
    expect(page).to have_content("Sua reserva foi realizada. Em breve, a #{@inn.brand_name} entrará em contato com você.")
  end
end
