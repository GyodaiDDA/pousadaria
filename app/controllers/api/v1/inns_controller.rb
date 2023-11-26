class Api::V1::InnsController < ActionController::API
  def index
    @inns = if params['search'].nil?
              Inn.all
            else
              Inn.where('brand_name LIKE ? OR city LIKE ? OR zone LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
            end
    render json: @inns.as_json(except: %i[user_id legal_name vat_number created_at updated_at])
  end

  def show
    @inn = Inn.find(params['id'])
    render json: @inn.as_json(except: %i[user_id legal_name vat_number created_at updated_at]).merge(avg_rating: @inn.avg_rating)
  rescue StandardError => e
    render json: "404. #{e}", status: :not_found
  end
end
