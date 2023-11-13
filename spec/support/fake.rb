def cities
  @ufs = %w[BA ES MS RN SP SC]
  @cidades = ['Casa Nova', 'Dom Macedo Costa', 'Bauru', 'Formosa do Sul', 'Brejo do Cruz', 'Porto', 'São Domingos do Prata']
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
  cities
  Inn.create!(brand_name: "Pousada #{Faker::Food.ingredients} #{Faker::Gender.type}",
                         legal_name: "#{Faker::Job.title} #{Faker::Lorem.words} #{Faker::Company.suffix}",
                         vat_number: Faker::Company.brazilian_company_number,
                         description: Faker::Company.buzzword,
                         address: "#{Faker::Address.street_suffix} #{Faker::Address.street_name}, #{Faker::Address.building_number}", #{Faker::Address."",
                         city: @cidades.sample.to_s,
                         state: @ufs.sample.to_s,
                         postal_code: Faker::Address.postcode,
                         active: true,
                         user: owner)
end

def make_rooms(inn, num = 1, features = { bathroom: 0, balcony: 0, air_conditioning: 0, tv: 0, wardrobe: 0, safe: 0, accessible: 0, available: 1 })
  num.times do
    Room.create!(name: "Quarto #{Faker::Color.color_name}",
                 description: "Um quarto de cair o #{Faker::Food.spice}",
                 size: rand(15..40),
                 max_guests: rand(1..5),
                 base_price: rand(100..500),
                 bathroom: features[:bathroom],
                 balcony: features[:balcony],
                 air_conditioning: features[:air_conditioning],
                 tv: features[:tv],
                 wardrobe: features[:wardrobe],
                 safe: features[:safe],
                 accessible: features[:accessible],                 
                 available: features[:available],
                 inn:)
  end
  inn.rooms.first
end
