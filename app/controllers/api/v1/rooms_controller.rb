class Api::V1::RoomsController < ActionController::API
  def index
    inn = Inn.find_by(id: params[:inn_id])
    if inn.nil?
      render json: 'Invalid query. Not acceptable.', status: :not_acceptable
    else
      rooms = Room.where(inn_id: inn.id).where(available: true)
      if rooms.empty?
        render json: 'Ok, but no content found', status: :ok
      else
        render json: rooms.as_json, status: :ok
      end
    end
  end
end
