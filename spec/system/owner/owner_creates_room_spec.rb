require 'rails_helper'

describe '::Owner cadastra novo quarto' do
  before(:each) do
    owner = Owner.create(email: 'usuario@servidor.co.uk', password: '.SenhaSuper3', type: 'Owner')
    Inn.create(brand_name: 'Pousada Recanto do Sossego',
               legal_name: 'Recanto do Sossego Hospedagens LTDA',
               vat_number: '12345678000911',
               phone: '(11) 99999-9999',
               email: 'contato@recantodosossego.com.br',
               address: 'Rua das Palmeiras, 100',
               zone: 'Zona Rural',
               city: 'Jundiaí',
               state: 'SP',
               postal_code: '13200-000',
               description: 'Uma pousada tranquila no coração da natureza, perfeita para relaxar.',
               payment_options: 'Dinheiro, Cartão de Crédito, Transferência Bancária',
               pet_friendly: true,
               wheelchair_accessible: true,
               rules: 'Não é permitido fumar nas dependências da pousada. Horário de silêncio após as 22h.',
               check_in: Time.zone.parse('14:00'),
               check_out: Time.zone.parse('12:00'),
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
    expect(current_path).to eq(inn_path('1'))
    expect(page).to have_content('Quarto Orlindgans foi adicionado com sucesso!')
  end
end
