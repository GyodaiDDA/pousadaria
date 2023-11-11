require 'rails_helper'

describe '::Owner altera os dados da pousada' do
  before(:each) do
    owner = Owner.create!(email: 'usuario@servidor.co.uk',
                          password: '.SenhaSuper3',
                          user_type: 'Owner')
    Inn.create!(brand_name: 'Pousada Recanto do Sossego',
                legal_name: 'Recanto do Sossego Hospedagens LTDA',
                vat_number: '11.222.333/0001-81',
                city: 'Saramandaia',
                state: 'RJ',
                postal_code: '13200-000',
                active: true,
                user_id: owner.id)
    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: 'usuario@servidor.co.uk'
    fill_in 'Senha', with: '.SenhaSuper3'
    within('div.actions') do
      click_on 'Entrar'
    end
    click_on 'Minha Pousada'
  end

  it 'com sucesso' do
    # Arrange
    # Act
    click_on 'Editar Pousada'
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
    click_on 'Editar Pousada'
    fill_in 'CNPJ', with: '1234567800911'
    click_on 'Atualizar Pousada'
    # Assert
    expect(current_path).to eq(inn_path('1'))
    expect(page).to have_content('Não foi possível atualizar a pousada.')
  end

  it 'e falha por Razão Social vazia' do
    # Arrange
    # Act
    click_on 'Editar Pousada'
    fill_in 'Razão Social', with: ''
    click_on 'Atualizar Pousada'
    # Assert
    expect(current_path).to eq(inn_path('1'))
    expect(page).to have_content('Não foi possível atualizar a pousada.')
  end
end
