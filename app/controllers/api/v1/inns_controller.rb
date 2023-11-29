class Api::V1::InnsController < ActionController::API
  def index
    @inns = if params['search'].nil?
              Inn.all
            else
              Inn.where('brand_name LIKE ? OR city LIKE ? OR zone LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
            end
    render json: @inns.as_json(only: %i[id brand_name city state phone email])
  end

  def show
    @inn = Inn.find(params['id'])
    render json: @inn.as_json(except: %i[user_id legal_name vat_number created_at updated_at]).merge(avg_rating: @inn.avg_rating)
  rescue StandardError
    render json: 'Não foi possível encontrar a informação.', status: :not_found
  end

  def cities
    @cities = Inn.pluck(:city, :state)
    render json: @cities.as_json, status: :ok if @cities.present?
    render json: [], status: :no_content if @cities.blank?
  rescue StandardError
    render json: 'Não foi possível encontrar a informação.', status: :not_found
  end

  def location
    @inns = Inn.by_location(params)
    render json: @inns.as_json, status: :ok if @inns.present?
    render json: [], status: :no_content if @inns.blank?
  rescue StandardError => e
    render json: "#{e} Não foi possível encontrar a informação.", status: :not_found
  end
end
