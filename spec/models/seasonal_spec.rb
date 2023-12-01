require 'rails_helper'

RSpec.describe Seasonal, type: :model do
  it 'é válida com todos os atributos' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.create!(name: 'Quarto Azul',
                        description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                        size: 36, max_guests: 5, base_price: 135, inn_id: inn.id)
    seasonal = Seasonal.new(room_id: room.id,
                            name: 'Promoção de Festas',
                            start_date: Time.zone.tomorrow + 30.days,
                            end_date: Time.zone.tomorrow + 34.days,
                            special_price: (room.base_price * 0.85).to_i)
    expect(seasonal).to be_valid
  end

  it 'é inválida sem nome' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.create!(name: 'Quarto Azul',
                        description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                        size: 36, max_guests: 5, base_price: 135, inn_id: inn.id)
    seasonal = Seasonal.new(room_id: room.id,
                            name: nil,
                            start_date: Time.zone.tomorrow + 30.days,
                            end_date: Time.zone.tomorrow + 34.days,
                            special_price: (room.base_price * 0.85).to_i)
    expect(seasonal).to be_valid
  end

  it 'é inválida sem data inicial' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.create!(name: 'Quarto Azul',
                        description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                        size: 36, max_guests: 5, base_price: 135, inn_id: inn.id)
    seasonal = Seasonal.new(room_id: room.id,
                            name: nil,
                            start_date: nil,
                            end_date: Time.zone.tomorrow + 34.days,
                            special_price: (room.base_price * 0.85).to_i)
    expect(seasonal).not_to be_valid
  end

  it 'é inválida sem data final' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.create!(name: 'Quarto Azul',
                        description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                        size: 36, max_guests: 5, base_price: 135, inn_id: inn.id)
    seasonal = Seasonal.new(room_id: room.id,
                            name: nil,
                            start_date: Time.zone.tomorrow + 30.days,
                            end_date: nil,
                            special_price: (room.base_price * 0.85).to_i)
    expect(seasonal).not_to be_valid
  end

  it 'é inválida sem preço especial' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.create!(name: 'Quarto Azul',
                        description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                        size: 36, max_guests: 5, base_price: 135, inn_id: inn.id)
    seasonal = Seasonal.new(room_id: room.id,
                            name: nil,
                            start_date: Time.zone.tomorrow + 30.days,
                            end_date: Time.zone.tomorrow + 34.days,
                            special_price: nil)
    expect(seasonal).not_to be_valid
  end

  it 'é inválida com data final menor que data inicial' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.create!(name: 'Quarto Azul',
                        description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                        size: 36, max_guests: 5, base_price: 135, inn_id: inn.id)
    seasonal = Seasonal.new(room_id: room.id,
                            name: nil,
                            start_date: Time.zone.tomorrow + 30.days,
                            end_date: Time.zone.tomorrow + 29.days,
                            special_price: (room.base_price * 0.85).to_i)
    expect(seasonal).not_to be_valid
  end

  it 'é inválida com data passada' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.create!(name: 'Quarto Azul',
                        description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                        size: 36, max_guests: 5, base_price: 135, inn_id: inn.id)
    seasonal = Seasonal.new(room_id: room.id,
                            name: nil,
                            start_date: Time.zone.yesterday,
                            end_date: Time.zone.tomorrow + 34.days,
                            special_price: (room.base_price * 0.85).to_i)
    expect(seasonal).not_to be_valid
  end
end
