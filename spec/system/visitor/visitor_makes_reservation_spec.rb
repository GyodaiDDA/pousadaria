require 'rails_helper'

describe '::Visitante consulta reserva de quarto' do
  it 'e não há disponibilidade de data' do
    # Arrange
    @inn = make_inn(make_owner)
    @room = make_room(@inn)
    @reservation = consult_reservation(@room, 3)
    # Act
    visit root_path
    click_on @inn.brand_name
    click_on @room.name
    click_on 'Quero reservar'
    fill_in 'Data de Entrada', with: @reservation.start_date + 1
    fill_in 'Data de Saída', with: @reservation.end_date + 1
    select rand(1..@room.max_guests).to_s, from: 'Hóspedes'
    click_button 'Fazer Reserva'
    # Assert
    expect(current_path).to eq(room_path(@room.id))
    expect(page).to have_content('Que pena! Quarto indisponível para esta reserva.')
  end

  context 'e há disponibilidade' do
    it 'mas precisa fazer login' do
      # Arrange
      @inn = make_inn(make_owner)
      @room = make_room(@inn)
      # Act
      visit root_path
      click_on @inn.brand_name
      click_on @room.name
      click_on 'Quero reservar'
      fill_in 'Data de Entrada', with: Time.zone.today + 1.day
      fill_in 'Data de Saída', with: Time.zone.today + 3.days
      select rand(1..@room.max_guests).to_s, from: 'Hóspedes'
      click_button 'Fazer Reserva'
      # Assert
      expect(current_path).to eq(room_reservation_path(@room, Reservation.last))
      expect(page).to have_content('Legal! Quarto disponível para esta reserva.')
      expect(page).to have_content("Código: #{Reservation.last.code}")
      expect(page).to have_content('Garanta sua reserva fazendo login no site.')
      expect(page).to have_field('E-mail')
      expect(page).to have_field('Senha')
      expect(page).to have_button('Entrar')
    end

    it 'e faz o login' do
      # Arrange
      @inn = make_inn(make_owner)
      @room = make_room(@inn)
      @visitor_account = make_customer('CPF')
      # Act
      visit root_path
      click_on @inn.brand_name
      click_on @room.name
      click_on 'Quero reservar'
      fill_in 'Data de Entrada', with: Time.zone.today + 1.day
      fill_in 'Data de Saída', with: Time.zone.today + 3.days
      select rand(1..@room.max_guests).to_s, from: 'Hóspedes'
      click_button 'Fazer Reserva'
      within 'form#new_user' do
        fill_in 'E-mail', with: @visitor_account.email
        fill_in 'Senha', with: @visitor_account.password
        click_on 'Entrar'
      end
      # Assert
      expect(current_path).to eq(room_reservation_path(@room, Reservation.last))
      expect(page).to have_content('Seu login foi feito com sucesso')
      expect(page).to have_content("Código: #{Reservation.last.code}")
      expect(page).to have_content("até as #{I18n.localize(Reservation.last.room.inn.check_in)}")
      expect(page).to have_content("até as #{I18n.localize(Reservation.last.room.inn.check_out)}")
      expect(page).to have_content("Check-in: #{I18n.localize(Reservation.last.start_date)}")
      expect(page).to have_content("Check-out: #{I18n.localize(Reservation.last.end_date)}")
      expect(page).to have_content("Acomodações: #{Reservation.last.room.name}")
      expect(page).to have_button('Confirmar Reserva')
    end

    it 'e confirma a reserva' do
      # Arrange
      @inn = make_inn(make_owner)
      @room = make_room(@inn)
      @visitor_account = make_customer('CPF')
      # Act
      visit root_path
      click_on @inn.brand_name
      click_on @room.name
      click_on 'Quero reservar'
      fill_in 'Data de Entrada', with: Time.zone.today + 1.day
      fill_in 'Data de Saída', with: Time.zone.today + 3.days
      select rand(1..@room.max_guests).to_s, from: 'Hóspedes'
      click_button 'Fazer Reserva'
      within 'form#new_user' do
        fill_in 'E-mail', with: @visitor_account.email
        fill_in 'Senha', with: @visitor_account.password
        click_on 'Entrar'
      end
      click_button 'Confirmar Reserva'
      # Assert
      expect(current_path).to eq(room_reservation_path(@room, Reservation.last))
      expect(page).to have_content("Sua reserva foi realizada. Em breve, a #{@inn.brand_name} entrará em contato com você.")
    end
  end
end
