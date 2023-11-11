require 'rails_helper'

describe '::Owner cadastra pousada' do
  context 'com sucesso' do
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
      fill_in 'CNPJ', with: '11222333000181'
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
      owner = Owner.create(email: 'usuario@servidor.co.uk', password: '.SenhaSuper3', user_type: 'Owner')
      login_as(owner)
      # Act
      visit root_path
      click_on('Cadastrar Pousada')
      fill_in 'Nome Fantasia', with: 'Pousada Recanto do Sossego'
      fill_in 'Razão Social', with: 'Recanto do Sossego Hospedagens LTDA'
      fill_in 'CNPJ', with: '11222333000181'
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

  context 'e falha' do
    before(:each) do
      owner = Owner.create(email: 'usuario@servidor.co.uk', password: '.SenhaSuper3', user_type: 'Owner')
      login_as(owner)
      visit root_path
      click_on('Cadastrar Pousada')
    end

    it 'na validação de CNPJ' do
      # Arrange
      # Act
      fill_in 'Nome Fantasia', with: 'Pousada Recanto do Sossego'
      fill_in 'Razão Social', with: 'Recanto do Sossego Hospedagens LTDA'
      fill_in 'CNPJ', with: '11222533000182'
      fill_in 'Cidade', with: 'Jundiaí'
      fill_in 'UF', with: 'SP'
      fill_in 'CEP', with: '13200-000'
      click_on 'Adicionar Pousada'
      # Assert
      expect(page).to have_content 'Não foi possível cadastrar a pousada.'
      expect(page).to have_content 'CNPJ inválido.'
    end

    it 'por faltar Nome Fantasia' do
      # Arrange
      # Act
      fill_in 'Razão Social', with: 'Recanto do Sossego Hospedagens LTDA'
      fill_in 'CNPJ', with: '11222333000182'
      fill_in 'Cidade', with: 'Jundiaí'
      fill_in 'UF', with: 'SP'
      fill_in 'CEP', with: '13200-000'
      click_on 'Adicionar Pousada'
      # Assert
      expect(page).to have_content 'Não foi possível cadastrar a pousada.'
      expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
    end
  end

  context 'e visualiza a pousada' do
    it 'clicando em Minha Pousada' do
      # Arrange
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
      # Act
      visit root_path
      click_on 'Entrar'
      fill_in 'E-mail', with: 'usuario@servidor.co.uk'
      fill_in 'Senha', with: '.SenhaSuper3'
      click_on 'Entrar'
      click_on 'Minha Pousada'
      # Assert
      expect(page).to have_content('Pousada Recanto do Sossego')
      expect(page).to have_content('Recanto do Sossego Hospedagens LTDA')
      expect(page).to have_content('Saramandaia')
    end
  end
end
