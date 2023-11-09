class InnsController < ApplicationController
  before_action :set_inn, only: %i[show edit update]
  before_action :set_rooms, only: %i[show]
  before_action :block_customers, only: %i[new create edit]
  before_action :block_owners_with_inn, only: %i[new create]

  def index
    @inns = Inn.all
    @active_inns = Inn.all.select { |inn| inn.active == true }
  end

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

  def cities
    @inns_by_city = Inn.order(:city).group_by(&:city)
    @cities_list = @inns_by_city.keys
  end

  private

  def block_owners_with_inn
    redirect_to inn_path(@inn), notice: 'Sua pousada já está cadastrada.' if @inn
  end

  def set_inn
    @inn = Inn.find(params[:id])
    check_ownership(@inn)
  end

  def set_rooms
    @rooms = Room.all.select { |room| room.inn_id == @inn.id && room.available == true }
  end

  def inn_params
    params.require(:inn).permit(:brand_name, :legal_name, :vat_number, :phone, :email, :address, :zone, :city, :state,
                                :postal_code, :description, :payment_options, :pet_friendly, :wheelchair_accessible,
                                :rules, :check_in, :check_out, :active, :user_id)
  end
end
