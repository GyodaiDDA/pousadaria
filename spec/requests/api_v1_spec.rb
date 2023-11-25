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
end
