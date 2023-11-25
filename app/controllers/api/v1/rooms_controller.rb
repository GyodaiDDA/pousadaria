class Api::V1::RoomsController < ActionController::API
  def index
    @rooms = Room.where(inn_id: params[:inn_id]).where(available: true)
    render json: @rooms.as_json
  rescue StandardError
    render status: :not_found
  end

  def show; end
end
