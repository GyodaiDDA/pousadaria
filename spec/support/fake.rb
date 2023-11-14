def cities
  %w['Casa Nova' 'Dom Macedo' 'Bauru' 'Formosa do Sul' 'Brejo da Cruz' 'Porto de São Domingos' 'Tereréu do Prata']
end

def states
  %w[BA ES MS RN SP SC]
end

def make_owner
  Owner.create!(
    email: Faker::Internet.email,
    password: 'password',
    password_confirmation: 'password',
    user_type: 'Owner'
  )
end

def make_customer
  Customer.create!(
    email: Faker::Internet.email,
    password: 'password',
    password_confirmation: 'password',
    user_type: 'Customer'
  )
end

def make_inn(owner)
  Inn.create!(brand_name: "Pousada #{Faker::Food.ingredients} #{Faker::Gender.type}",
              legal_name: "#{Faker::Job.title} #{Faker::Color.color_name} #{Faker::Company.suffix}",
              vat_number: Faker::Company.brazilian_company_number,
              description: Faker::Company.buzzword,
              address: "#{Faker::Address.street_suffix} #{Faker::Address.street_name}, #{Faker::Address.building_number}",
              city: cities.sample.to_s, state: states.sample.to_s, postal_code: Faker::Address.postcode,
              pet_friendly: [true, false].sample, wheelchair_accessible: [true, false].sample,
              active: true,
              user: owner)
end

def make_rooms(inn, num = 1, features = { bathroom: 0, balcony: 0, air_conditioning: 0, tv: 0, wardrobe: 0, safe: 0, accessible: 0, available: 0 })
  num.times do
    Room.create!(name: "Quarto #{Faker::Color.color_name}", description: "Um quarto de cair o #{Faker::Food.spice}",
                 size: rand(15..40), max_guests: rand(1..5), base_price: rand(100..500),
                 bathroom: features[:bathroom], balcony: features[:balcony], air_conditioning: features[:air_conditioning], tv: features[:tv],
                 wardrobe: features[:wardrobe], safe: features[:safe], accessible: features[:accessible], available: features[:available], inn:)
  end
end

def make_seasonals(room, num = 1)
  num.times do
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
end
