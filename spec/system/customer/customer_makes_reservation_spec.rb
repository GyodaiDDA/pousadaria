require 'rails_helper'

describe '::Customer faz reserva de quarto' do
  it 'com sucesso' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer = make_customer('cpf')
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
    click_button 'Efetivar reserva'
    # Assert
    expect(current_path).to eq(edit_room_reservation_path(@room.id, 1))
    expect(page).to have_content("Sua reserva foi realizada. Em breve, a #{@inn.brand_name} entrará em contato com você.")
  end

  it 'mas precisa cadastrar CPF' do
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
    click_button 'Efetivar reserva'
    # Assert
    expect(current_path).to eq('Adicionar CPF')
    expect(page).to have_field('CPF')
    expect(page).to have_button('Completar cadastro')
  end

  it 'depois de cadastrar CPF' do
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
    click_button 'Efetivar reserva'
    fill_in 'CPF', with: make_cpf
    click_on 'Completar cadastro'
    # Assert
    expect(current_path).to eq(room_reservation_path(@room.id, @customer.reservation.last.id))
    expect(page).to have_content("Sua reserva foi realizada. Em breve, a #{@inn.brand_name} entrará em contato com você.")
  end
end
