require 'rails_helper'

describe '::Visitante acessa o site' do
  before(:each) do
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
               vat_number: '44568987000522',
               city: 'Mandarucaia',
               state: 'ES',
               postal_code: '29260-000',
               active: true,
               user_id: owner.id)
    Inn.create!(brand_name: 'Pousada Tremelengo',
               legal_name: 'Tamoios Inc.',
               vat_number: '04569875000122',
               city: 'São Sebastião',
               state: 'SP',
               postal_code: '11452-100',
               active: true,
               user_id: owner.id)
    Inn.create!(brand_name: 'Pousada Atrasada',
               legal_name: 'Tamoios Inc.',
               vat_number: '04569875000232',
               city: 'Caraguatatuba',
               state: 'SP',
               postal_code: '11580-000',
               active: true,
               user_id: owner.id)
    visit root_path
    @count = Inn.all.size
  end

  it 'e vê as pousadas mais recentes' do
    # Arrange
    # Act
    # Assert
    expect(@count).to eq 4
    expect(current_path).to eq(root_path)
    expect(page).to have_content('POUSADARIA')
    within('#recent') do
      expect(page).to have_content('Pousada Recanto do Sossego')
      expect(page).to have_content('Rio das Pedras/MG')
      expect(page).to have_content('Pousada da Balada Roxa')
      expect(page).to have_content('Mandarucaia/ES')
      expect(page).to have_content('Pousada Tremelengo')
      expect(page).to have_content('São Sebastião/SP')
    end
  end

  it 'e as pousadas antigas' do
    # Arrange
    # Act
    # Assert
    within('section#all') do
      expect(page).to have_content('Pousada Atrasada')
      expect(page).to have_content('Caraguatatuba/SP')
    end
  end
end
