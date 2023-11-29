require 'rails_helper'

describe '::API v1 Inns' do
  context 'GET /api/v1/inns/' do
    it 'succeeds' do
      # Arrange
      @owner1 = make_owner
      @inn1 = make_inn(@owner1)
      @owner2 = make_owner
      @inn2 = make_inn(@owner2)
      @owner3 = make_owner
      @inn3 = make_inn(@owner3)
      # Act
      get api_v1_inns_path
      # Assert
      expect(response.status).to eq(200)
      expect(response.content_type).to include('application/json')

      json_response = JSON.parse(response.body)

      expect(json_response[0]['brand_name']).to eq(@inn1.brand_name)
      expect(json_response[1]['brand_name']).to eq(@inn2.brand_name)
      expect(json_response[2]['brand_name']).to eq(@inn3.brand_name)
    end

    it 'fails' do
      # Arrange
      @owner1 = make_owner
      @inn1 = make_inn(@owner1)
      @owner2 = make_owner
      @inn2 = make_inn(@owner2)
      @owner3 = make_owner
      @inn3 = make_inn(@owner3)
      # Act
      get api_v1_inns_path
      # Assert
      expect(response.status).to eq(200)
      expect(response.content_type).to include('application/json')

      JSON.parse(response.body).each do |register|
        expect(register.keys).not_to include('created_at')
        expect(register.keys).not_to include('updated_at')
      end
    end
  end

  context 'GET /api/v1/inn/' do
    it 'succeeds' do
      # Arrange
      @owner = make_owner
      @inn = make_inn(@owner)
      @room1 = make_room(@inn)
      @room2 = make_room(@inn)
      # Act
      get api_v1_inn_path(@inn.id)
      # Assert
      expect(response.status).to eq(200)
      expect(response.content_type).to include('application/json')
      expect(response.body).to include(@inn.brand_name)
      expect(response.body).to include(@inn.phone)
      expect(response.body).to include(@inn.email)
      expect(response.body).to include(@inn.address)
      expect(response.body).to include(@inn.zone)
      expect(response.body).to include(@inn.city)
      expect(response.body).to include(@inn.state)
      expect(response.body).to include(@inn.postal_code)
      expect(response.body).to include(@inn.description)
      expect(response.body).to include("\"pet_friendly\":#{@inn.pet_friendly}")
      expect(response.body).to include("\"wheelchair_accessible\":#{@inn.wheelchair_accessible}")
      expect(response.body).to include(@inn.rules)
      # expect(response.body).to include(@inn.check_in.utc.iso8601)
      # expect(response.body).to include(@inn.check_out)
      expect(response.body).to include("\"active\":#{@inn.active}")
      expect(response.body).to include(@inn.payment_opt)
      expect(response.body).to include(@inn.avg_rating.to_s)
    end

    it 'fails' do
      # Arrange
      # Act
      get api_v1_inn_path(Inn.all.size + 10)
      # Assert
      expect(response.status).to eq(404)
      expect(response.content_type).to include('application/json')
      expect(response.body).to include('Não foi possível encontrar a informação.')
    end
  end

  context 'GET api_v1_inn_rooms' do
    it 'succeeds' do
      # Arrange
      @owner = make_owner
      @inn = make_inn(@owner)
      @room1 = make_room(@inn)
      @room2 = make_room(@inn)
      @room2.available = false
      @room2.save
      # Act
      get api_v1_inn_rooms_path(@inn.id)
      # Assert
      expect(response.status).to eq(200)
      expect(response.content_type).to include('application/json')
      expect(response.body).to include(@room1.name)
      expect(response.body).to include(@room1.description)
      expect(response.body).to include(@room1.size.to_s)
      expect(response.body).to include(@room1.max_guests.to_s)
      expect(response.body).to include(@room1.base_price.to_s)
      expect(response.body).to include("\"air_conditioning\":#{@room1.air_conditioning}")
      expect(response.body).to include("\"tv\":#{@room1.tv}")
      expect(response.body).to include("\"accessible\":#{@room1.accessible}")
      expect(response.body).to include("\"available\":#{@room1.available}")
      expect(response.body).not_to include(@room2.name)
    end

    it 'it is empty' do
      # Arrange
      @owner = make_owner
      @inn = make_inn(@owner)
      @room1 = make_room(@inn)
      @room1.available = false
      @room1.save
      # Act
      get api_v1_inn_rooms_path(@inn.id)
      # Assert
      expect(response.status).to eq(200)
      expect(response.body).to include('Ok, but no content found')
      expect(response.body).not_to include(@room1.name)
    end

    it 'fails' do
      # Arrange
      # Act
      get api_v1_inn_rooms_path(Inn.all.size + 10)
      # Assert
      expect(response.status).to eq(406)
      expect(response.body).to include('Invalid query. Not acceptable.')
    end
  end

  context 'POST api_v1_room_reservation' do
    it 'succeeds: available' do
      # Arrange
      owner = make_owner
      inn = make_inn(owner)
      room = make_room(inn)
      # Act
      reservation_params = { reservation: { room_id: room.id, start_date: Time.zone.today + 1..5.days, end_date: Time.zone.today + 6..10.days, guests: rand(1..room.max_guests) } }
      post api_v1_room_reservation_path(1), params: reservation_params
      # Assert
      expect(response.status).to eq(201)
      expect(response.content_type).to include('application/json')
      expect(response.body).to include(Reservation.last.code)
      expect(response.body).to include(Reservation.last.estimate.to_s)
    end

    it 'succeeds: unavailable' do
      # Arrange
      owner = make_owner
      inn = make_inn(owner)
      room = make_room(inn)
      reservation1 = make_reservation(room)
      # Act
      reservation_params = { reservation: { room_id: room.id, start_date: reservation1.start_date + 1, end_date: reservation1.end_date + 2, guests: rand(1..room.max_guests) } }
      post api_v1_room_reservation_path(2), params: reservation_params
      # Assert
      expect(response.status).to eq(202)
      expect(response.content_type).to include('application/json')
      expect(response.body).to include('Não há disponibilidade para a reserva')
    end

    it 'fails' do
      # Arrange
      owner = make_owner
      inn = make_inn(owner)
      room = make_room(inn)
      # Act
      reservation_params = { reservation: { room_id: room.id, start_date: Time.zone.today + 1..5.days, end_date: Time.zone.tomorrow, guests: rand(1..room.max_guests) } }
      post api_v1_room_reservation_path(1), params: reservation_params
      # Assert
      expect(response.status).to eq(422)
      expect(response.content_type).to include('application/json')
      expect(response.body).to include('A data final não pode ser menor que a data inicial')
    end
  end

  context 'GET api_v1_cities' do
    it 'succeeds' do
      # Arrange
      ['Casa Nova', 'Dom Macedo', 'Bauru', 'Formosa do Sul', 'Brejo da Cruz', 'Porto de São Domingos'].each do |city|
        owner = make_owner
        make_inn(owner, city)
      end
      # Act
      get api_v1_cities_path
      # Assert
      expect(response.status).to eq(200)
      expect(response.content_type).to include('application/json')
      expect(response.body).to include('Casa Nova')
      expect(response.body).to include('Dom Macedo')
      expect(response.body).to include('Bauru')
      expect(response.body).to include('Formosa do Sul')
      expect(response.body).to include('Brejo da Cruz')
      expect(response.body).to include('Porto de São Domingos')
    end

    it 'fails' do
      # Arrange
      # Act
      get api_v1_cities_path
      # Assert
      expect(response.status).to eq(204)
      expect(response.body).not_to include('Casa Nova')
      expect(response.body).not_to include('Bauru')
    end
  end

  context 'GET api_v1_location' do
    it 'succeeds / city & state' do
      # Arrange
      @inn1 = make_inn(make_owner)
      @inn2 = make_inn(make_owner)
      @inn3 = make_inn(make_owner)
      @inn1.update(brand_name: 'Paulistana da Gema', city: 'São Paulo', state: 'SP')
      @inn2.update(brand_name: 'Pousada Mineirinha', city: 'Belo Horizonte', state: 'MG')
      @inn3.update(brand_name: 'Bauruense', city: 'Bauru', state: 'SP')
      # Act
      get api_v1_location_path, params: { city: 'São Paulo', state: 'SP' }
      # Assert
      expect(response.status).to eq(200)
      expect(response.content_type).to include('application/json')
      expect(response.body).to include('Paulistana da Gema')
      expect(response.body).not_to include('Pousada Mineirinha')
      expect(response.body).not_to include('Bauruense')
    end

    it 'succeeds / city' do
      # Arrange
      @inn1 = make_inn(make_owner)
      @inn2 = make_inn(make_owner)
      @inn3 = make_inn(make_owner)
      @inn4 = make_inn(make_owner)
      @inn1.update(brand_name: 'Paulistana da Gema', city: 'São Paulo', state: 'SP')
      @inn2.update(brand_name: 'Pousada Mineirinha', city: 'Belo Horizonte', state: 'MG')
      @inn3.update(brand_name: 'Bauruense', city: 'Bauru', state: 'SP')
      @inn4.update(brand_name: 'Aconchego do Interior', city: 'São Paulo', state: 'MG')
      # Act
      get api_v1_location_path, params: { city: 'São Paulo' }
      # Assert
      expect(response.status).to eq(200)
      expect(response.content_type).to include('application/json')
      expect(response.body).to include('Paulistana da Gema')
      expect(response.body).to include('Aconchego do Interior')
      expect(response.body).not_to include('Bauruense')
      expect(response.body).not_to include('Pousada Mineirinha')
    end

    it 'succeeds / state' do
      # Arrange
      @inn1 = make_inn(make_owner)
      @inn2 = make_inn(make_owner)
      @inn3 = make_inn(make_owner)
      @inn4 = make_inn(make_owner)
      @inn1.update(brand_name: 'Paulistana da Gema', city: 'São Paulo', state: 'SP')
      @inn2.update(brand_name: 'Pousada Mineirinha', city: 'Belo Horizonte', state: 'MG')
      @inn3.update(brand_name: 'Bauruense', city: 'Bauru', state: 'SP')
      @inn4.update(brand_name: 'Aconchego do Interior', city: 'São Paulo', state: 'MG')
      # Act
      get api_v1_location_path, params: { state: 'MG' }
      # Assert
      expect(response.status).to eq(200)
      expect(response.content_type).to include('application/json')
      expect(response.body).not_to include('Paulistana da Gema')
      expect(response.body).to include('Aconchego do Interior')
      expect(response.body).not_to include('Bauruense')
      expect(response.body).to include('Pousada Mineirinha')
    end

    it 'succeeds / 204' do
      # Arrange
      @inn1 = make_inn(make_owner)
      @inn2 = make_inn(make_owner)
      @inn3 = make_inn(make_owner)
      @inn4 = make_inn(make_owner)
      @inn1.update(brand_name: 'Paulistana da Gema', city: 'São Paulo', state: 'SP')
      @inn2.update(brand_name: 'Pousada Mineirinha', city: 'Belo Horizonte', state: 'MG')
      @inn3.update(brand_name: 'Bauruense', city: 'Bauru', state: 'SP')
      @inn4.update(brand_name: 'Aconchego do Interior', city: 'São Paulo', state: 'MG')
      # Act
      get api_v1_location_path, params: { city: 'New York' }
      # Assert
      expect(response.status).to eq(204)
      expect(response.body).not_to include('Paulistana da Gema')
      expect(response.body).not_to include('Aconchego do Interior')
      expect(response.body).not_to include('Bauruense')
      expect(response.body).not_to include('Pousada Mineirinha')
    end
  end
end
