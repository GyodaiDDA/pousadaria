require 'rails_helper'

describe '::Customer acessa reserva concluída' do
  it 'e visualiza formulário de avaliação' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer = make_customer('cpf')
    @reservation = make_closed_reservation(@room, @customer)
    # Act
    visit root_path
    login(@customer)
    click_on 'Minhas Reservas'
    click_on @reservation.code
    # Assert
    expect(page).to have_content('Avalie a sua estadia')
    expect(page).to have_field('Nota')
    expect(page).to have_field('Comentário')
    expect(page).to have_button('Avaliar')
  end

  it 'e envia avaliação com sucesso' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer = make_customer('cpf')
    @reservation = make_closed_reservation(@room, @customer)
    # Act
    visit root_path
    login(@customer)
    click_on 'Minhas Reservas'
    click_on @reservation.code
    select 4, from: 'Nota'
    fill_in 'Comentário', with: 'Apreciei bastante, pessoal super simpático e o lugar é uma fofura.'
    click_on 'Avaliar'
    # Assert
    expect(page).to have_content('4')
    expect(page).to have_content('Apreciei bastante, pessoal super simpático e o lugar é uma fofura.')
    expect(page).not_to have_button('Avaliar')
  end

  it 'e vê a resposta da pousada' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
    @customer = make_customer('cpf')
    @reservation = make_answered_reservation(@room, @customer)
    # Act
    visit root_path
    login(@customer)
    click_on 'Minhas Reservas'
    click_on @reservation.code
    # Assert
    expect(page).to have_content(@reservation.grade)
    expect(page).to have_content('Seu comentário')
    expect(page).to have_content(@reservation.response)
    expect(page).not_to have_button('Avaliar')
  end
end
