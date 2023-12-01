require 'rails_helper'

RSpec.describe Reservation, type: :model do
  it 'é válida com os atributos básicos' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.create!(name: 'Quarto Azul',
                        description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                        size: 36, max_guests: 5, base_price: 135, inn_id: inn.id)
    reservation = Reservation.new(room_id: room.id,
                                  start_date: Time.zone.tomorrow,
                                  end_date: Time.zone.tomorrow + 4.days,
                                  guests: 5)
    expect(reservation).to be_valid
  end

  it 'é inválida sem data inicial' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.create!(name: 'Quarto Azul',
                        description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                        size: 36, max_guests: 5, base_price: 135, inn_id: inn.id)
    reservation = Reservation.new(room_id: room.id,
                                  start_date: nil,
                                  end_date: Time.zone.tomorrow + 4.days,
                                  guests: 4)
    expect(reservation).not_to be_valid
  end

  it 'é inválida sem data final' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.create!(name: 'Quarto Azul',
                        description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                        size: 36, max_guests: 5, base_price: 135, inn_id: inn.id)
    reservation = Reservation.new(room_id: room.id,
                                  start_date: Time.zone.tomorrow,
                                  end_date: nil,
                                  guests: 4)
    expect(reservation).not_to be_valid
  end

  it 'é inválida com data final menor que data inicial' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.create!(name: 'Quarto Azul',
                        description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                        size: 36, max_guests: 5, base_price: 135, inn_id: inn.id)
    reservation = Reservation.new(room_id: room.id,
                                  start_date: Time.zone.tomorrow + 10.days,
                                  end_date: Time.zone.tomorrow + 9.days,
                                  guests: 4)
    expect(reservation).not_to be_valid
  end

  it 'é inválida com datas passadas' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.create!(name: 'Quarto Azul',
                        description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                        size: 36, max_guests: 5, base_price: 135, inn_id: inn.id)
    reservation = Reservation.new(room_id: room.id,
                                  start_date: Time.zone.yesterday,
                                  end_date: Time.zone.tomorrow + 9.days,
                                  guests: 4)
    expect(reservation).not_to be_valid
  end

  it 'é inválida com número de hóspedes maior que a capacidade' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.create!(name: 'Quarto Azul',
                        description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                        size: 36, max_guests: 5, base_price: 135, inn_id: inn.id)
    reservation = Reservation.new(room_id: room.id,
                                  start_date: Time.zone.tomorrow,
                                  end_date: Time.zone.tomorrow + 9.days,
                                  guests: 6)
    expect(reservation).not_to be_valid
  end

  it 'é inválida sem id do quarto' do
    reservation = Reservation.new(room_id: nil,
                                  start_date: Time.zone.tomorrow,
                                  end_date: Time.zone.tomorrow + 4.days,
                                  guests: 4)
    expect(reservation).not_to be_valid
  end

  it 'é inválida sem número de hóspedes' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.create!(name: 'Quarto Azul',
                        description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                        size: 36, max_guests: 5, base_price: 135, inn_id: inn.id)
    reservation = Reservation.new(room_id: room.id,
                                  start_date: Time.zone.tomorrow,
                                  end_date: Time.zone.tomorrow + 4.days,
                                  guests: nil)
    expect(reservation).not_to be_valid
  end

  it 'é inválida com 0 hóspedes' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.create!(name: 'Quarto Azul',
                        description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                        size: 36, max_guests: 5, base_price: 135, inn_id: inn.id)
    reservation = Reservation.new(room_id: room.id,
                                  start_date: Time.zone.tomorrow,
                                  end_date: Time.zone.tomorrow + 4.days,
                                  guests: 0)
    expect(reservation).not_to be_valid
  end
end
