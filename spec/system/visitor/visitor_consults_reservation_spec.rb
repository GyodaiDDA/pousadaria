require 'rails_helper'

describe '::Visitante consulta reserva de quarto' do
  context 'clicando no botão Fazer Reserva' do
    before(:each) do
      @inn = make_inn(make_owner)
      @room = make_rooms(@inn, { tv: true, bathroom: true, safe: true, available: true })
    end

    it 'e vê detalhes do quarto' do
      # Arrange
      # Act
      visit root_path
      click_on @inn.brand_name
      click_on @room.name
      click_button 'Quero reservar'
      # Assert
      expect(current_path).to eq(new_room_reservation_path(@room.id))
      expect(page).to have_field('Data de Entrada')
      expect(page).to have_field('Data de Saída')
      expect(page).to have_field('Hóspedes')
      expect(page).to have_button('Fazer Reserva')
    end

    it 'e não há disponibilidade de data' do
      # Arrange
      @reservation = consult_reservation(@room, 3)
      # Act
      visit root_path
      click_on @inn.brand_name
      click_on @room.name
      click_on 'Quero reservar'
      fill_in 'Data de Entrada', with: @reservation.start_date + 1
      fill_in 'Data de Saída', with: @reservation.end_date + 1
      select '1', from: 'Hóspedes'
      click_button 'Fazer Reserva'
      # Assert
      expect(current_path).to eq(room_path(@room.id))
      expect(page).to have_content('Que pena! Quarto indisponível para esta reserva.')
    end

    it 'e há disponibilidade' do
      # Arrange
      @reservation = consult_reservation(@room, 3)
      # Act
      visit root_path
      click_on @inn.brand_name
      click_on @room.name
      click_on 'Quero reservar'
      fill_in 'Data de Entrada', with: @reservation.end_date + 4
      fill_in 'Data de Saída', with: @reservation.end_date + 7
      select rand(1..@room.max_guests).to_s, from: 'Hóspedes'
      click_button 'Fazer Reserva'
      # Assert
      expect(current_path).to eq(room_reservation_path(@room, @reservation.id + 1))
      expect(page).to have_content('Legal! Quarto disponível para esta reserva.')
      expect(page).to have_content('Valor total')
      expect(page).to have_content('Valor por diária')
      expect(page).to have_content('Valor por pessoa')
      expect(page).to have_button('Efetivar reserva')
    end
  end
end
