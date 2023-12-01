require 'rails_helper'

RSpec.describe Visitor, type: :model do
  it 'é válido com todos os atributos' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                      email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                      user_id: owner.id)
    room = Room.create!(name: 'Quarto Azul',
                        description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                        size: 36, max_guests: 5, base_price: 135, inn_id: inn.id)
    reservation = Reservation.create!(room_id: room.id,
                                      start_date: Time.zone.tomorrow,
                                      end_date: Time.zone.tomorrow + 4.days,
                                      guests: 5)
    visitor = Visitor.new(full_name: 'Gedorcildo de Oliveira',
                          email: 'gedorcilo_maroto@aol.com.es',
                          document: '052658798-80',
                          reservation_id: reservation.id)
    expect(visitor).to be_valid
  end

  context 'é inválido sem' do
    it 'nome completo' do
      owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
      inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                        email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                        user_id: owner.id)
      room = Room.create!(name: 'Quarto Azul',
                          description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                          size: 36, max_guests: 5, base_price: 135, inn_id: inn.id)
      reservation = Reservation.create!(room_id: room.id,
                                        start_date: Time.zone.tomorrow,
                                        end_date: Time.zone.tomorrow + 4.days,
                                        guests: 5)
      visitor = Visitor.new(full_name: nil,
                            email: 'gedorcilo_maroto@aol.com.es',
                            document: '052658798-80',
                            reservation_id: reservation.id)
      expect(visitor).not_to be_valid
    end

    it 'documento' do
      owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
      inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                        email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                        user_id: owner.id)
      room = Room.create!(name: 'Quarto Azul',
                          description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                          size: 36, max_guests: 5, base_price: 135, inn_id: inn.id)
      reservation = Reservation.create!(room_id: room.id,
                                        start_date: Time.zone.tomorrow,
                                        end_date: Time.zone.tomorrow + 4.days,
                                        guests: 5)
      visitor = Visitor.new(full_name: 'Gedorcildo de Oliveira',
                            email: nil,
                            document: '052658798-80',
                            reservation_id: reservation.id)
      expect(visitor).not_to be_valid
    end

    it 'e-mail' do
      owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
      inn = Inn.create!(brand_name: 'Pousada Mexilhões do Leste', legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI', vat_number: '71167614000704',
                        email: 'lynelle_schults@grimes.test.co', city: 'Porto de São Domingos', state: 'RN', postal_code: '48763-149', check_in: '10:00', check_out: '13:00',
                        user_id: owner.id)
      room = Room.create!(name: 'Quarto Azul',
                          description: 'Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
                          size: 36, max_guests: 5, base_price: 135, inn_id: inn.id)
      reservation = Reservation.create!(room_id: room.id,
                                        start_date: Time.zone.tomorrow,
                                        end_date: Time.zone.tomorrow + 4.days,
                                        guests: 5)
      visitor = Visitor.new(full_name: 'Gedorcildo de Oliveira',
                            email: 'gedorcilo_maroto@aol.com.es',
                            document: nil,
                            reservation_id: reservation.id)
      expect(visitor).not_to be_valid
    end

    it 'reservation_id' do
      visitor = Visitor.new(full_name: 'Gedorcildo de Oliveira',
                            email: 'gedorcilo_maroto@aol.com.es',
                            document: '052658798-80',
                            reservation_id: nil)
      expect(visitor).not_to be_valid
    end
  end
end
