require 'rails_helper'

describe '::Owner cadastra novo quarto' do
  it 'clicando em Adicionar Quarto' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    visit root_path
    login(@owner)
    # Act
    click_on 'Minha Pousada'
    click_on 'Adicionar Quarto'
    # Assert]
    expect(current_path).to eq(new_room_path)
    expect(page).to have_field('Nome')
    expect(page).to have_field('Descrição')
    expect(page).to have_field('Área (m²)')
    expect(page).to have_field('Hóspedes')
    expect(page).to have_field('Preço Base')
    expect(page).to have_field('Banheiro')
    expect(page).to have_field('Varanda')
    expect(page).to have_field('Ar-condicionado')
    expect(page).to have_field('TV')
    expect(page).to have_field('Guarda-roupas')
    expect(page).to have_field('Cofre')
    expect(page).to have_field('Acessível')
    expect(page).to have_field('Disponível')
    expect(page).to have_button('Adicionar Quarto')
  end

  it 'e falha na validação de Área' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    visit root_path
    login(@owner)
    # Act
    click_on 'Minha Pousada'
    click_on 'Adicionar Quarto'
    fill_in 'Nome', with: 'Quarto Orlindgans'
    fill_in 'Descrição', with: 'Quarto amplo, com varanda, para aproveitar ao máximo os dias'
    fill_in 'Área', with: 'fs'
    fill_in 'Hóspedes', with: '2'
    fill_in 'Preço Base', with: '300'
    check 'Banheiro'
    check 'Varanda'
    check 'Ar-condicionado'
    uncheck 'TV'
    check 'Guarda-roupas'
    uncheck 'Acessível'
    check 'Disponível'
    click_on 'Adicionar Quarto'
    # Assert]
    expect(page).to have_content('Não foi possível adicionar o quarto.')
    expect(page).to have_content('Área (m²) não é um número')
  end

  it 'e falha por falta do nome' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    visit root_path
    login(@owner)
    # Act
    click_on 'Minha Pousada'
    click_on 'Adicionar Quarto'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: 'Quarto amplo, com varanda, para aproveitar ao máximo os dias'
    fill_in 'Área', with: '30'
    fill_in 'Hóspedes', with: '2'
    fill_in 'Preço Base', with: '300'
    check 'Banheiro'
    check 'Varanda'
    check 'Ar-condicionado'
    uncheck 'TV'
    check 'Guarda-roupas'
    uncheck 'Acessível'
    check 'Disponível'
    click_on 'Adicionar Quarto'
    # Assert]
    expect(page).to have_content('Não foi possível adicionar o quarto.')
    expect(page).to have_content('Nome não pode ficar em branco')
  end

  it 'com sucesso' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    visit root_path
    login(@owner)
    # Act
    click_on 'Minha Pousada'
    click_on 'Adicionar Quarto'
    fill_in 'Nome', with: 'Quarto Orlindgans'
    fill_in 'Descrição', with: 'Quarto amplo, com varanda, para aproveitar ao máximo os dias'
    fill_in 'Área', with: '30'
    fill_in 'Hóspedes', with: '2'
    fill_in 'Preço Base', with: '300'
    check 'Banheiro'
    check 'Varanda'
    check 'Ar-condicionado'
    uncheck 'TV'
    check 'Guarda-roupas'
    uncheck 'Acessível'
    check 'Disponível'
    click_on 'Adicionar Quarto'
    # Assert]
    expect(current_path).to eq(room_path(Room.last.id))
    expect(page).to have_content('Quarto Orlindgans foi adicionado com sucesso!')
  end
end
