require 'rails_helper'

describe '::Owner altera os dados da pousada' do
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
    click_on 'Editar'
  end

  it 'com sucesso' do
    # Arrange
    # Act
    fill_in 'Endereço', with: 'Rua das Lavadeiras S/N'
    uncheck 'Ativa?'
    click_on 'Atualizar Pousada'
    # Assert
    expect(current_path).to eq(inn_path('1'))
    expect(page).to have_content('Sua pousada foi atualizada com sucesso!')
  end

  it 'e falha por validação de cpnj' do
    # Arrange
    # Act
    fill_in 'CNPJ', with: '1234567800911'
    click_on 'Atualizar Pousada'
    # Assert
    expect(current_path).to eq(inn_path('1'))
    expect(page).to have_content('Não foi possível atualizar a pousada.')
  end
end
