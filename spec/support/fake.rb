def city_name
  ['Casa Nova', 'Dom Macedo', 'Bauru', 'Formosa do Sul', 'Brejo da Cruz', 'Porto de São Domingos', 'Tereréu do Prata', 'Aparatéu de Baixo', 'Piraporinha do Santo Manco', 'Itapiranga', 'Jundiaí', 'Carvalinho Dengoso do Sul']
end

def state_letters
  %w[BA ES MS RN SP SC]
end

def room_desc
  ['Quarto rústico com paredes de pedra, cama de casal com dossel e uma lareira aconchegante.','Estilo minimalista, com cama queen-size, paredes brancas e uma grande janela com vista para o jardim.',
   'Decoração tropical, com cama king-size, redes, e muitas plantas verdes.', 'Quarto temático de praia, com parede azul-celeste, cama king-size e acessórios náuticos.',
   'Suíte luxuosa com jacuzzi, cama super king-size e um mini-bar completo.', 'Quarto vintage com papel de parede floral, cama de ferro antiga e móveis de época.',
   'Decoração moderna, com cama de plataforma, iluminação LED e um sistema de som integrado.', 'Suíte romântica com pétalas de rosas na cama, velas aromáticas e uma pequena varanda.',
   'Quarto de estilo boêmio, com tapetes coloridos, almofadas no chão e muita arte nas paredes.', 'Suíte de luxo com vista para o mar, cama king-size e um terraço privativo.',
   'Quarto com tema de floresta, com papel de parede de árvores, cama com dossel e sons da natureza.', 'Estilo loft industrial, com paredes de tijolos, cama queen-size e decoração metálica.',
   'Quarto de estilo oriental, com tatames, futons e decoração Zen.', 'Suíte familiar grande, com uma cama king-size e duas de solteiro, além de uma pequena área de estar.',
   'Quarto acolhedor de chalé, com muita madeira, uma cama queen-size e uma vista para as montanhas.', 'Estilo cabana de praia, com piso de madeira, cama de casal e decoração marítima.',
   'Quarto com temática medieval, com cama de dossel, tapeçarias e armaduras decorativas.', 'Decoração contemporânea, com cama de casal, arte moderna nas paredes e móveis elegantes.',
   'Suíte com tema de safári, com decoração africana, cama king-size e tecidos estampados.', 'Quarto de estilo francês, com cama de dossel, espelhos ornamentados e cortinas de seda.', 'Ambiente rústico moderno, com cama queen-size, paredes de madeira reciclada e iluminação industrial.']
end

def inn_desc
  ['Chalés aconchegantes com uma vista panorâmica do vale perfeito para quem curte um visual de cair o queixo.', 'Local ideal para os amantes de trilhas e aventuras com acesso direto a várias rotas de trekking.',
   'Uma pousadinha tranquila escondida na floresta com um jardim zen pra quem busca sossego.', 'Quartos temáticos inspirados nas fases da lua super romântico para casais.',
   'Pousada com vibe praiana decoração vibrante e um bar que serve os melhores coquetéis.', 'Acorda com o canto dos pássaros perfeito para quem é amante da natureza.',
   'Fica no alto de uma montanha com uma vista de tirar o fôlego e trilhas para caminhadas épicas.', 'Estilo rústico com aquele café da manhã caseiro que só vovó sabe fazer.',
   'À beira de um lago sereno com opções de passeios de caiaque e pesca.', 'Decoração elegante com um jardim cheio de orquídeas e uma atmosfera super relaxante.',
   'Vibração jovem perfeito para fazer novas amizades e curtir uma festa.', 'Pousada minimalista e tranquila ideal para quem quer se desconectar do mundo lá fora.',
   'Temática rústica com direito a passeios a cavalo e uma fogueira para curtir à noite.', 'Decoração temática de piratas com um bar subterrâneo secreto.',
   'Chalés nas alturas com um visual incrível da cidade abaixo e um céu estrelado inesquecível.', 'Totalmente sustentável com energia solar e atividades de conscientização ambiental.',
   'De frente para o mar com um píer privativo e quartos com vista para o oceano.', 'Quartos temáticos baseados em contos de fadas um lugar mágico para crianças e adultos.',
   'Uma mistura de pousada e retiro espiritual com aulas de yoga e meditação.', 'Decorada com obras de arte com estúdios disponíveis para hóspedes criativos.',
   'Temática de castelo com torres muralhas e até um banquete estilo medieval.', 'Cercada por um jardim botânico com trilhas secretas e cantinhos de leitura ao ar livre.',
   'Cada quarto representa um país diferente perfeito para viajantes que amam culturas diversas.', 'No topo de um penhasco com uma vista de águia e a sensação de estar acima das nuvens.',
   'Com várias piscinas naturais e cachoeiras ideal para quem busca refresco e tranquilidade.', 'Uma pousada com labirintos e enigmas para resolver um desafio e tanto!', 'Localizada em meio a dunas com tendas luxuosas e noites estreladas épicas.']
end

def make_owner
  User.create!(
    email: Faker::Internet.email,
    password: 'password',
    password_confirmation: 'password',
    user_type: 'Owner'
  )
end

def make_customer(cpf = '')
  if cpf.include?('cpf') || cpf.include?('CPF')
    User.create!(
    full_name: Faker::Name.name,
    email: Faker::Internet.email,
    document: Faker::IDNumber.brazilian_citizen_number,
    password: 'password',
    password_confirmation: 'password',
    user_type: 'Customer'
  )
  else
    User.create!(
    full_name: Faker::Name.name,
    email: Faker::Internet.email,
    password: 'password',
    password_confirmation: 'password',
    user_type: 'Customer'
  )
  end
  
end

def make_cpf(user = nil)
  if user.nil?
    Faker::IDNumber.brazilian_citizen_number
  else
    user.document = Faker::IDNumber.brazilian_citizen_number
  end
end

def make_inn(owner, active = 1)
  Inn.create!(brand_name: "Pousada #{Faker::Food.ingredients} #{Faker::Gender.type}",
              legal_name: "#{Faker::Job.title} #{Faker::Space.moon} #{Faker::Company.suffix}",
              vat_number: Faker::Company.brazilian_company_number,
              phone: Faker::PhoneNumber.phone_number,
              email: Faker::Internet.email,
              address: "#{Faker::Address.street_suffix} #{Faker::Address.street_name}, #{Faker::Address.building_number}",
              zone: "#{['Vila', 'Jd.', 'Recanto'].sample} #{Faker::Address.city}",
              city: city_name.sample, state: state_letters.sample, postal_code: Faker::Address.postcode,
              description: inn_desc.sample,
              payment_opt: ["Cartão de Crédito", "Cartão de Débito, Pix", "Pix, Dinheiro, Transferência", "Dinheiro", "PayPal", "Todos os cartões e GooglePay"].sample,
              pet_friendly: [true, false].sample,
              wheelchair_accessible: [true, false, false, false, true].sample,
              rules: "#{Faker::ElectricalComponents.active} todos os #{Faker::ElectricalComponents.passive} enquanto o #{Faker::Space.planet} não der a volta completa em #{Faker::Space.moon}.",
              check_in: "#{rand(10..14)}:00",
              check_out: "#{rand(11..16)}:00",
              active: active,
              user_id: owner.id)
end

def make_room(inn, features = {available: 1} )
  Room.create!(name: "Quarto #{Faker::Color.color_name}",
              description: room_desc.sample,
              size: rand(15..40),
              max_guests: [1,2,2,3,3,3,4,4,5].sample,
              base_price: rand(100..500),
              bathroom: features[:bathroom] ? features[:bathroom] : [true, true, true, false].sample,
              balcony: features[:balcony] ? features[:balcony] : [true, false].sample,
              air_conditioning: features[:air_conditioning] ? features[:air_conditioning] : [true, true, false].sample,
              tv: features[:tv] ? features[:tv] : [true, true, true, true, true, true, false].sample,
              wardrobe: features[:wardrobe] ? features[:wardrobe] : [true, true, true, true, true, true, false].sample,
              safe: features[:safe] ? features[:safe] : [true, false].sample,
              accessible: features[:accessible] ? features[:accessible] : [true, false, false].sample,
              available: features[:available],
              inn_id: inn.id
  )
end

def make_seasonals(room)
    if room.seasonals.last
      start_date = room.seasonals.last.end_date + 10
    else 
      start_date = Date.today + rand(10..20)
    end
    end_date = start_date + rand(10..20)
    Seasonal.create!(name: Faker::Space.moon,
                      start_date: start_date,
                      end_date: end_date,
                      special_price: rand(room.base_price) + rand(-200..200),
                      room_id: room.id)
end

def consult_reservation(room, period = rand(10..20))
  if room.reservations.last
    start_date = room.reservations.last.end_date + 7
  else 
    start_date = Date.today + rand(10..20)
  end
  end_date = start_date + period
  Reservation.create!(start_date: start_date,
                      end_date: end_date,
                      guests: rand(0..room.max_guests),
                      room_id: room.id)
end

def make_customer_reservation(room, customer, start_date = nil, period = rand(10..20).days)
  if start_date.nil?
    if room.reservations.last
      start_date = room.reservations.last.end_date + 7
    else 
      start_date = Date.today + rand(10..20).days
    end
  end
  end_date = start_date + period
  Reservation.create!(start_date: start_date,
                      end_date: end_date,
                      guests: rand(1..room.max_guests),
                      room_id: room.id,
                      estimate: (end_date - start_date).to_i * room.base_price,
                      user_id: customer.id)
end


def make_closed_reservation(room, customer, start_date = nil, period = rand(10..20).days)
  reservation = make_customer_reservation(room, customer)
  reservation.check_in = Time.now.change(year: reservation.start_date.year, month: reservation.start_date.month, day: reservation.start_date.day)
  reservation.check_out = Time.now.change(year: reservation.end_date.year, month: reservation.end_date.month, day: reservation.end_date.day) + 2.hours
  reservation.status = 'closed'
  reservation.total_value = reservation.estimate
  reservation.payment = 'Cartão de crédito'
  reservation.save
  reservation.nights = (reservation.end_date - reservation.start_date).to_i
  reservation.save
  reservation
end