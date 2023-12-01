require 'rails_helper'

RSpec.describe Inn, type: :model do
  it 'é válido com todos os atributos' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.new(brand_name: 'Pousada Mexilhões do Leste',
                  legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI',
                  vat_number: '71167614000704',
                  phone: '(75) 6470-9961',
                  email: 'lynelle_schults@grimes.test.co',
                  address: 'Rodovia Viela Fabrício Soeira, 7812',
                  zone: 'Recanto do Uarini',
                  city: 'Porto de São Domingos',
                  state: 'RN',
                  postal_code: '48763-149',
                  description: 'Quartos temáticos inspirados nas fases da lua super romântico para casais.',
                  pet_friendly: true,
                  wheelchair_accessible: false,
                  rules: 'LCD todos os TrimPot enquanto o Júpiter não der a volta completa em Dia da Mulher.',
                  check_in: '10:00',
                  check_out: '13:00',
                  active: true,
                  user_id: owner.id,
                  payment_opt: 'Cartão de Débito, Pix')
    expect(inn).to be_valid
  end

  it 'é válido com atributos básicos' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.new(brand_name: 'Pousada Mexilhões do Leste',
                  legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI',
                  vat_number: '71167614000704',
                  email: 'lynelle_schults@grimes.test.co',
                  city: 'Porto de São Domingos',
                  state: 'RN',
                  postal_code: '48763-149',
                  check_in: '10:00',
                  check_out: '13:00',
                  user_id: owner.id)
    expect(inn).to be_valid
  end

  it 'é inválido com CNPJ fora do padrão' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.new(brand_name: 'Pousada Mexilhões do Leste',
                  legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI',
                  vat_number: '71167614000703',
                  email: 'lynelle_schults@grimes.test.co',
                  city: 'Porto de São Domingos',
                  state: 'RN',
                  postal_code: '48763-149',
                  check_in: '10:00',
                  check_out: '13:00',
                  user_id: owner.id)
    expect(inn).not_to be_valid
  end

  it 'é inválido sem CNPJ' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.new(brand_name: 'Pousada Mexilhões do Leste',
                  legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI',
                  vat_number: nil,
                  email: 'lynelle_schults@grimes.test.co',
                  city: 'Porto de São Domingos',
                  state: 'RN',
                  postal_code: '48763-149',
                  check_in: '10:00',
                  check_out: '13:00',
                  user_id: owner.id)
    expect(inn).not_to be_valid
  end

  it 'é inválido sem Nome Fantasia' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.new(brand_name: nil,
                  legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI',
                  vat_number: '71167614000704',
                  email: 'lynelle_schults@grimes.test.co',
                  city: 'Porto de São Domingos',
                  state: 'RN',
                  postal_code: '48763-149',
                  check_in: '10:00',
                  check_out: '13:00',
                  user_id: owner.id)
    expect(inn).not_to be_valid
  end

  it 'é inválido sem Razão Social' do
    owner = User.create!(email: 'test@example.com', password: 'password', user_type: 'Owner')
    inn = Inn.new(brand_name: 'Pousada Mexilhões do Leste',
                  legal_name: nil,
                  vat_number: '71167614000704',
                  email: 'lynelle_schults@grimes.test.co',
                  city: 'Porto de São Domingos',
                  state: 'RN',
                  postal_code: '48763-149',
                  check_in: '10:00',
                  check_out: '13:00',
                  user_id: owner.id)
    expect(inn).not_to be_valid
  end

  it 'é inválido sem user_id' do
    customer = User.create!(email: 'test@example.com', password: 'password', user_type: 'Customer')
    inn = Inn.new(brand_name: 'Pousada Mexilhões do Leste',
                  legal_name: 'Especialista de Imobiliária Junior Dia da Mulher EIRELI',
                  vat_number: '71167614000704',
                  email: 'lynelle_schults@grimes.test.co',
                  city: 'Porto de São Domingos',
                  state: 'RN',
                  postal_code: '48763-149',
                  check_in: nil,
                  check_out: '13:00',
                  user_id: customer.id)
    expect(inn).not_to be_valid
  end
end
