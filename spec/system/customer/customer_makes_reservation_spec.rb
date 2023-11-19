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
    click_button 'Confirmar Reserva'
    # Assert
    expect(current_path).to eq(room_reservation_path(@room.id, 1))
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
    # Assert
    expect(current_path).to eq(room_reservation_path(@room.id, 1))
    expect(page).not_to have_button('Confirmar Reserva')
    expect(page).to have_content('Para confirmar sua reserva, complete os dados do seu cadastro usando o formulário ao lado.')
    expect(page).to have_field('Nome completo')
    expect(page).to have_field('CPF')
    expect(page).to have_button('Atualizar')
  end

  it 'e atualiza cadastro' do
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
    fill_in 'Nome completo', with: 'Teodoro Ruzivelt'
    fill_in 'CPF', with: make_cpf
    click_on 'Atualizar'
    # Assert
    expect(current_path).to eq(room_reservation_path(@room.id, @customer.reservation.last.id))
    expect(page).to have_content('Seu cadastrado foi atualizado.')
  end
end
