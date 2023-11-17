require 'rails_helper'

describe '::Owner altera os dados da pousada' do
  it 'com sucesso' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    visit root_path
    login(@owner)
    click_on 'Minha Pousada'
    # Act
    click_on 'Editar Pousada'
    fill_in 'Endereço', with: 'Rua das Lavadeiras S/N'
    uncheck 'Ativa?'
    click_on 'Atualizar Pousada'
    # Assert
    expect(current_path).to eq(inn_path(@inn.id))
    expect(page).to have_content('Sua pousada foi atualizada com sucesso!')
  end

  it 'e não pode alterar o cpnj' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    visit root_path
    login(@owner)
    click_on 'Minha Pousada'
    # Act
    click_on 'Editar Pousada'
    # Assert
    expect(current_path).to eq(edit_inn_path(@inn.id))
    expect(page).not_to have_field('CNPJ')
  end

  it 'e falha por Razão Social vazia' do
    # Arrange
    @owner = make_owner
    @inn = make_inn(@owner)
    visit root_path
    login(@owner)
    click_on 'Minha Pousada'
    # Act
    click_on 'Editar Pousada'
    fill_in 'Razão Social', with: ''
    click_on 'Atualizar Pousada'
    # Assert
    expect(current_path).to eq(inn_path(@inn.id))
    expect(page).to have_content('Não foi possível atualizar a pousada.')
  end
end
