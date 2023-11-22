class InnsController < ApplicationController
  before_action :set_inn, only: %i[show edit update]
  before_action :set_rooms, only: %i[show]

  def index; end

  def show; end

  def new
    @inn = Inn.new
  end

  def create
    @inn = Inn.new(inn_params)
    if @inn.save
      redirect_to @inn, notice: 'Sua pousada foi cadastrada com sucesso!'
    else
      flash[:alert] = 'Não foi possível cadastrar a pousada.'
      render 'new'
    end
  end

  def edit; end

  def update
    if @inn.update(inn_params)
      redirect_to inn_path, notice: 'Sua pousada foi atualizada com sucesso!'
    else
      flash[:notice] = 'Não foi possível atualizar a pousada.'
      render 'edit'
    end
  end

  def city
    @inns_by_city = Inn.all.where('active = 1').order(:city).order(:brand_name).group_by(&:city)
  end

  def by_cities
    @inns_by_city = Inn.all.where('active = 1').order(:city).order(:brand_name).group_by(&:city)
  end

  def search
    @key = params[:search]
    @active_inns =
      Inn.where('brand_name LIKE ? OR city LIKE ? OR zone LIKE ?', "%#{@key}%", "%#{@key}%", "%#{@key}%")
  end

  def reservations
    return unless user_signed_in?

    @inn = current_user.inn
    @reservations = Reservation.where(room: @inn.rooms)
  end

  private

  def set_inn
    if params[:id].present?
      @inn = Inn.find(params[:id])
      @owner_view = the_owner?(@inn)
    elsif current_user.present?
      @inn = current_user.inn
    end
  end

  def set_rooms
    @available_rooms = @inn.rooms.select { |room| room.available == true }
  end

  def inn_params
    params.require(:inn).permit(:brand_name, :legal_name, :vat_number, :phone, :email, :address, :zone, :city, :state,
                                :postal_code, :description, :payment_options, :pet_friendly, :wheelchair_accessible,
                                :rules, :check_in, :check_out, :active, :user_id)
  end
end
