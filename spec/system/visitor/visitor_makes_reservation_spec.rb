require 'rails_helper'

describe '::Visitante reserva quarto de pousada' do
  context 'clicando no botão Reservar' do
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
      expect(page).to have_field('Date de Saída')
      expect(page).to have_field('Quantidade de Hóspedes')
      expect(page).to have_button('Consultar')
    end

    it 'e não há disponibilidade de data' do
      # Arrange
      @reservation = make_reservation
      # Act
      visit root_path
      click_on @inn.brand_name
      click_on @room.name
      fill_in 'Data de Entrada', with: @reservation.start_date
      fill_in 'Date de Saída', with: @reservation.end_date
      fill_in 'Quantidade de Hóspedes', with: rand(1..@room.max_guests)
      click_button 'Consultar'
      # Assert
      expect(current_path).to eq(new_room_reservation_path(@room.id))
      expect(page).to have_content('Que pena! Quarto indisponível para esta reserva.')
    end

    it 'e há disponibilidade' do
      # Arrange
      @reservation = make_reservation
      # Act
      visit root_path
      click_on @inn.brand_name
      click_on @room.name
      fill_in 'Data de Entrada', with: @reservation.end_date + 4
      fill_in 'Date de Saída', with: @reservation.end_date + 7
      fill_in 'Quantidade de Hóspedes', with: rand(1..@room.max_guests)
      click_button 'Consultar'
      # Assert
      expect(current_path).to eq(new_room_reservation_path(@room.id))
      expect(page).to have_content('Legal! Quarto disponível para esta reserva.')
      expect(page).to have_content('Valor da reserva')
      expect(page).to have_content('Valor da diária')
      expect(page).to have_content('Valor por pessoa')
      expect(page).to have_button('Efetivar reservar')
    end
  end
end
