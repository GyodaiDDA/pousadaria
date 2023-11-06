require 'rails_helper'

describe '::Owner cadastra pousada' do
  it 'logo após criar sua conta.' do
    # Arrange
    # Act I
    visit root_path
    click_on 'Entrar'
    click_on 'Ainda não tem cadastro?'
    within('section#owner-signup') do
      fill_in 'E-mail', with: 'usuario@servidor.co.uk'
      fill_in 'Senha', with: '.SenhaSuper3'
      fill_in 'Confirme sua senha', with: '.SenhaSuper3'
      click_on 'Cadastre-se'
    end
    # Act II
    fill_in 'Nome Fantasia', with: 'Pousada Recanto do Sossego'
    fill_in 'Razão Social', with: 'Recanto do Sossego Hospedagens LTDA'
    fill_in 'CNPJ', with: '12345678000155'
    fill_in 'Telefone', with: '(11) 99999-9999'
    fill_in 'E-mail', with: 'contato@recantodosossego.com.br'
    fill_in 'Endereço', with: 'Rua das Palmeiras, 100'
    fill_in 'Bairro', with: 'Zona Rural'
    fill_in 'Cidade', with: 'Jundiaí'
    fill_in 'UF', with: 'SP'
    fill_in 'CEP', with: '13200-000'
    fill_in 'Descrição', with: 'Uma pousada tranquila no coração da natureza, perfeita para relaxar.'
    fill_in 'Formas de Pagto', with: 'Dinheiro, Cartão de Crédito, Transferência Bancária'
    check 'Aceita pet'
    check 'Acessível'
    fill_in 'Políticas de uso', with: 'Não é permitido fumar nas dependências da pousada. Horário de silêncio após as 22h.'
    fill_in 'Check-in', with: '10:00 am'
    fill_in 'Check-out', with: '14:00 pm'
    check 'Ativa'
    click_on 'Adicionar Pousada'
    # Assert
    expect(page).to have_content 'Sua pousada foi cadastrada com sucesso!'
  end

  it 'clicando em Cadastrar Pousada' do
    # Arrange
    owner = Owner.create(email: 'usuario@servidor.co.uk', password: '.SenhaSuper3', type: 'Owner')
    login_as(owner)
    # Act
    visit root_path
    click_on('Cadastrar Pousada')
    fill_in 'Nome Fantasia', with: 'Pousada Recanto do Sossego'
    fill_in 'Razão Social', with: 'Recanto do Sossego Hospedagens LTDA'
    fill_in 'CNPJ', with: '12345678000155'
    fill_in 'Telefone', with: '(11) 99999-9999'
    fill_in 'E-mail', with: 'contato@recantodosossego.com.br'
    fill_in 'Endereço', with: 'Rua das Palmeiras, 100'
    fill_in 'Bairro', with: 'Zona Rural'
    fill_in 'Cidade', with: 'Jundiaí'
    fill_in 'UF', with: 'SP'
    fill_in 'CEP', with: '13200-000'
    fill_in 'Descrição', with: 'Uma pousada tranquila no coração da natureza, perfeita para relaxar.'
    fill_in 'Formas de Pagto', with: 'Dinheiro, Cartão de Crédito, Transferência Bancária'
    check 'Aceita pet'
    check 'Acessível'
    fill_in 'Políticas de uso', with: 'Não é permitido fumar nas dependências da pousada. Horário de silêncio após as 22h.'
    fill_in 'Check-in', with: '10:00 am'
    fill_in 'Check-out', with: '14:00 pm'
    check 'Ativa'
    click_on 'Adicionar Pousada'
    # Assert
    expect(page).to have_content 'Sua pousada foi cadastrada com sucesso!'
  end
end
