require 'rails_helper'

describe '::Owner cria novo Período' do
  before(:each) do
    owner = Owner.create(email: 'usuario@servidor.co.uk',
                         password: '.SenhaSuper3',
                         user_type: 'Owner')
    inn = Inn.create(brand_name: 'Pousada Recanto do Sossego',
                     legal_name: 'Recanto do Sossego Hospedagens LTDA',
                     vat_number: '22333444000181',
                     postal_code: '13200-000',
                     city: 'Arruaces',
                     state: 'AC',
                     user_id: owner.id)
    @room = Room.create(name: 'Quarto Orlindgans',
                        size: 30,
                        max_guests: 2,
                        base_price: 300,
                        available: true,
                        inn_id: inn.id)
    login_as(owner)
    visit root_path
    click_on 'Minha Pousada'
    click_on 'Ver'
  end

  it 'clicando em Períodos Especiais' do
    # Arrange
    # Act
    click_on 'Adicionar Período Especial'
    # Assert
    expect(page).to have_field('Nome do Evento (opcional)')
    expect(page).to have_field('Data de Início')
    expect(page).to have_field('Data de Término')
    expect(page).to have_field('Preço no Período')
    expect(page).to have_button('Adicionar Período')
  end

  it 'com sucesso' do
    # Arrange
    # Act
    click_on 'Adicionar Período Especial'
    fill_in 'Nome do Evento (opcional)', with: 'Dia dos Namorados'
    fill_in 'Data de Início', with: '11/06/2024'
    fill_in 'Data de Término', with: '14/06/2024'
    fill_in 'Preço no Período', with: '200'
    click_on 'Adicionar Período Especial'
    # Assert
    expect(current_path).to eq(room_path(1))
    expect(page).to have_content('Período adicionado com sucesso')
  end

  it 'e falha por sobreposição de data' do
    # Arrange
    Seasonal.create(name: 'Dias de Verão', start_date: '12/06/2024',
                    end_date: '13/06/2024', special_price: 300, room_id: 1)
    # Act
    click_on 'Adicionar Período Especial'
    fill_in 'Nome do Evento (opcional)', with: 'Dia dos Namorados'
    fill_in 'Data de Início', with: '11/06/2024'
    fill_in 'Data de Término', with: '14/06/2024'
    fill_in 'Preço no Período', with: '200'
    click_on 'Adicionar Período Especial'
    # Assert
    expect(current_path).to eq(room_seasonals_path(1))
    expect(page).to have_content('Não foi possível adicionar o período')
    expect(page).to have_content('Já existem períodos para esta data neste quarto.')
  end

  it 'e falha por reversão de data' do
    # Arrange
    Seasonal.create(name: 'Dias de Verão', start_date: '12/06/2024',
                    end_date: '13/06/2024', special_price: 300, room_id: 1)
    # Act
    click_on 'Adicionar Período Especial'
    fill_in 'Nome do Evento (opcional)', with: 'Dia dos Namorados'
    fill_in 'Data de Início', with: '11/06/2024'
    fill_in 'Data de Término', with: '14/06/2023'
    fill_in 'Preço no Período', with: '200'
    click_on 'Adicionar Período Especial'
    # Assert
    expect(current_path).to eq(room_seasonals_path(1))
    expect(page).to have_content('Não foi possível adicionar o período')
    expect(page).to have_content('A data final não pode ser menor que a data inicial.')
  end

  it 'e falha por superação de data' do
    # Arrange
    Seasonal.create(name: 'Dias de Verão', start_date: '12/06/2024',
                    end_date: '13/06/2024', special_price: 300, room_id: 1)
    # Act
    click_on 'Adicionar Período Especial'
    fill_in 'Nome do Evento (opcional)', with: 'Dia dos Namorados'
    fill_in 'Data de Início', with: '11/06/2023'
    fill_in 'Data de Término', with: '14/06/2023'
    fill_in 'Preço no Período', with: '200'
    click_on 'Adicionar Período Especial'
    # Assert
    expect(current_path).to eq(room_seasonals_path(1))
    expect(page).to have_content('Não foi possível adicionar o período')
    expect(page).to have_content('As datas escolhidas já passaram.')
  end
end
