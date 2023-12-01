require 'rails_helper'

RSpec.describe Room, type: :model do
  it 'é válido com atributos básicos' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.new(name: 'Quarto Azul',
                    description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                    size: 36,
                    max_guests: 5,
                    base_price: 154,
                    inn_id: inn.id)
    expect(room).to be_valid
  end

  it 'é inválido sem capacidade de hóspedes' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.new(name: 'Quarto Azul',
                    description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                    size: 36,
                    max_guests: nil,
                    base_price: 154,
                    inn_id: inn.id)
    expect(room).not_to be_valid
  end

  it 'é inválido com capacidade 0 de hóspedes' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.new(name: 'Quarto Azul',
                    description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                    size: 36,
                    max_guests: 0,
                    base_price: 154,
                    inn_id: inn.id)
    expect(room).not_to be_valid
  end

  it 'é inválido com área 0' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.new(name: 'Quarto Azul',
                    description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                    size: 0,
                    max_guests: 5,
                    base_price: 154,
                    inn_id: inn.id)
    expect(room).not_to be_valid
  end

  it 'é inválido sem área' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.new(name: 'Quarto Azul',
                    description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                    size: nil,
                    max_guests: 5,
                    base_price: 154,
                    inn_id: inn.id)
    expect(room).not_to be_valid
  end

  it 'é inválido sem nome' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.new(name: nil,
                    description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                    size: 36,
                    max_guests: 5,
                    base_price: 154,
                    inn_id: inn.id)
    expect(room).not_to be_valid
  end

  it 'é inválido sem preço base' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.new(name: 'Quarto Azul',
                    description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                    size: 36,
                    max_guests: 5,
                    base_price: nil,
                    inn_id: inn.id)
    expect(room).not_to be_valid
  end
end
