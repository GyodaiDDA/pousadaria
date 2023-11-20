require 'rails_helper'

describe '::Customer consulta reserva' do
  it 'e não há disponibilidade de data' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @reservation = consult_reservation(@room, 3)
    @customer = make_customer
    # Act
    visit root_path
    login(@customer)
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

  context 'e atualiza cadastro' do
    it 'pelo formulário' do
      # Arrange
      @owner = make_owner
      @inn = make_inn(@owner)
      @room = make_room(@inn)
      @customer = make_customer
      # Act
      visit root_path
      login(@customer)
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
      expect(page).to have_content("Reserva #{@room.reservations.last.code}")
      expect(page).to have_content('Valor total')
      expect(page).to have_content('Complete seu cadastro e garanta sua reserva.')
      expect(page).to have_field('Nome completo')
      expect(page).to have_field('CPF')
      expect(page).to have_button('Atualizar')
    end

    it 'para fazer a reserva' do
      # Arrange
      @owner = make_owner
      @inn = make_inn(@owner)
      @room = make_room(@inn)
      @customer = make_customer
      # Act
      visit root_path
      login(@customer)
      click_on @inn.brand_name
      click_on @room.name
      click_on 'Quero reservar'
      fill_in 'Data de Entrada', with: Time.zone.today + 1.day
      fill_in 'Data de Saída', with: Time.zone.today + 3.days
      select rand(1..@room.max_guests).to_s, from: 'Hóspedes'
      click_button 'Fazer Reserva'
      fill_in 'CPF', with: make_cpf
      fill_in 'Senha atual', with: @customer.password
      click_button 'Atualizar'
      click_button 'Confirmar Reserva'
      # Assert
      expect(current_path).to eq(room_reservation_path(@room, Reservation.last))
      expect(page).to have_content("Sua reserva foi realizada. Em breve, a #{@inn.brand_name} entrará em contato com você.")
    end
  end
end
