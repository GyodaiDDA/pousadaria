class InnsController < ApplicationController
  before_action :set_inn, only: %i[show edit update]
  before_action :set_active_inns, only: %i[index search adv_search]

  before_action :no_inn, only: %i[new create]
  before_action only: %i[edit update] do
    the_owner?(@inn)
  end

  before_action :set_rooms, only: %i[show] # NECESSÁRIO?

  def index; end

  def show
    set_rooms
  end

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
    @inns_by_city = Inn.order(:city).order(:brand_name).group_by(&:city)
    @cities_list = @inns_by_city.keys
  end

  def search
    @key = params[:search]
    @active_inns =
      @active_inns.where('brand_name LIKE ? OR city LIKE ? OR zone LIKE ?', "%#{@key}%", "%#{@key}%", "%#{@key}%")
  end

  def adv_search
    @brand_name = params[:brand_name]
    @zone = params[:zone]
    @city = params[:city]
    @state = params[:state]
    @pet_friendly = "NULL"
    @tv = params[:tv]
    @bathroom = 0
    # @active_inns = @active_inns.where('brand_name LIKE ? AND zone LIKE ? AND city LIKE ? AND state LIKE ?', "%#{@brand_name}%", "%#{@zone}%", "%#{@city}%", "%#{@state}%")
    @active_inns = Inn.joins(:rooms).where("brand_name LIKE ? AND rooms.tv = ? OR inns.state = ?", "%#{@brand_name}%", false, @state).distinct

  end

  private

  def no_inn
    owners_only
    redirect_to inn_path(@inn), notice: 'Sua pousada já está cadastrada.' if @inn
  end

  def set_inn
    @inn = Inn.find(params[:id])
    @owner_view = the_owner?(@inn)
  end

  def set_active_inns
    @active_inns = Inn.all.where('active = 1').order(:brand_name)
  end

  def set_rooms
    @rooms = Room.all.select { |room| room.inn_id == @inn.id }
  end

  def inn_params
    params.require(:inn).permit(:brand_name, :legal_name, :vat_number, :phone, :email, :address, :zone, :city, :state,
                                :postal_code, :description, :payment_options, :pet_friendly, :wheelchair_accessible,
                                :rules, :check_in, :check_out, :active, :user_id)
  end
end
