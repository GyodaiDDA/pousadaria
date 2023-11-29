class InnsController < ApplicationController
  before_action :set_inn, only: %i[show edit update]

  def index; end

  def show; end

  def ratings; end

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

  def cities
    @inns_by_city = Inn.by_city
  end

  def search
    @key = params[:search]
    return if @key.blank?

    @active_inns =
      Inn.where('brand_name LIKE ? OR city LIKE ? OR zone LIKE ?', "%#{@key}%", "%#{@key}%", "%#{@key}%")
  end

  def reservations
    @reservations = ReservationsSelector.new({ inn: current_user.inn }).find
    @reservations = @reservations.active if params[:active].present?
  end

  private

  def set_inn
    @inn = Inn.find(params[:id])
    @owner_view = the_owner?(@inn)
  end

  def inn_params
    params.require(:inn).permit(:brand_name, :legal_name, :vat_number, :phone, :email, :address, :zone, :city, :state,
                                :postal_code, :description, :payment_opt, :pet_friendly, :wheelchair_accessible,
                                :rules, :check_in, :check_out, :active, :user_id)
  end
end
