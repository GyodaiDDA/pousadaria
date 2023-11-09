if Rails.env.development?

  ufs = ['BA', 'ES', 'MS', 'RN', 'SP', 'SC']
  cidades = ["Casa Nova", "Dom Macedo Costa", "Bauru", "Formosa do Sul", "Brejo do Cruz", "Porto", "São Domingos do Prata"]

  22.times do |i|
    owner = User.create!(
      email: Faker::Internet.email,
      password: 'password',
      password_confirmation: 'password',
      user_type: 'Owner'
    )

    inn = Inn.create!(
      brand_name: "Pousada #{Faker::Food.ingredients} #{Faker::Gender.type}",
      legal_name: "#{Faker::Job.title} #{Faker::Lorem.words} #{Faker::Company.suffix}",
      vat_number: Faker::Company.brazilian_company_number,
      description: Faker::Company.buzzword,
      address: "#{Faker::Address.street_suffix} #{Faker::Address.street_name}, #{Faker::Address.building_number}", #{Faker::Address."",
      city: "#{cidades.sample}",
      state: "#{ufs.sample}",
      postal_code: Faker::Address.postcode,
      user: owner
    )

    rand(1..4).times do |j|
      Room.create!(
        name: "Room #{Faker::Color.color_name}",
        description: "Um quarto de cair o #{Faker::Food.spice}",
        size: rand(15..40),
        max_guests: rand(1..5),
        base_price: rand(100..500),
        inn:
      )
    end
  end
end
