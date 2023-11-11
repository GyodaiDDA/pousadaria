require 'rails_helper'

describe '::Customer busca por pousadas' do
  before(:each) do
    customer = Customer.create!(email: 'perdido@naselva.com', password: 'perdido', user_type: 'Customer')
    owner = Owner.create!(email: 'usuario@servidor.co.uk', password: '.SenhaSuper3', user_type: 'Owner')
    Inn.create!(brand_name: 'Pousada Recanto do Sossego',
                legal_name: 'Recanto do Sossego Hospedagens LTDA',
                vat_number: '22333444000181',
                city: 'Rio das Pedras',
                state: 'MG',
                postal_code: '37653-000',
                active: true,
                user_id: owner.id)
    Inn.create!(brand_name: 'Pousada da Balada Roxa',
                legal_name: 'José Fernandez Queiroz 89232120911',
                vat_number: '22.325.669/0001-96',
                zone: 'Recanto Perdido',
                city: 'Mandarucaia',
                state: 'ES',
                postal_code: '29260-000',
                active: true,
                user_id: owner.id)
    Inn.create!(brand_name: 'Pousada Tremelengo',
                legal_name: 'Tamoios Inc.',
                vat_number: '00.580.370/0001-45',
                city: 'São Sebastião',
                state: 'SP',
                postal_code: '11452-100',
                active: true,
                user_id: owner.id)
    Inn.create!(brand_name: 'Pousada Atrasada',
                legal_name: 'Tamoios Inc.',
                vat_number: '44.401.318/0001-50',
                city: 'Caraguatatuba',
                state: 'SP',
                postal_code: '11580-000',
                active: true,
                user_id: owner.id)
    login_as(customer)
    visit root_path
  end

  it 'e recebe resultados' do
    # Arrange
    # Act
    visit root_path
    fill_in 'busca:', with: 'Recanto'
    click_on '>'
    # Assert
    expect(page).to have_content('2 pousadas encontradas')
    expect(page).to have_content('Pousada da Balada Roxa')
    expect(page).to have_content('Pousada Recanto do Sossego')
  end
end
