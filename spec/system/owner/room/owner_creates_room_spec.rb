require 'rails_helper'

describe '::Owner cadastra novo quarto' do
  before(:each) do
    owner = Owner.create!(email: 'usuario@servidor.co.uk', password: '.SenhaSuper3', user_type: 'Owner')
    Inn.create!(brand_name: 'Pousada Recanto do Sossego',
                legal_name: 'Recanto do Sossego Hospedagens LTDA',
                vat_number: '22333444000181',
                city: 'Rublas Gaúchas',
                state: 'RS',
                postal_code: '13200-000',
                active: true,
                user_id: owner.id)
    login_as(owner)
    visit root_path
    click_on 'Minha Pousada'
  end

  it 'clicando em Adicionar Quarto' do
    # Arrange
    # Act
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

  it 'e falha na validação' do
    # Arrange
    # Act
    click_on 'Adicionar Quarto'
    fill_in 'Nome', with: 'Quartin'
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
    expect(page).to have_content('Nome não pode ficar em branco')
  end

  it 'com sucesso' do
    # Arrange
    # Act
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
    expect(current_path).to eq(room_path('1'))
    expect(page).to have_content('Quarto Orlindgans foi adicionado com sucesso!')
  end
end
