class InnsController < ApplicationController
  before_action :set_inn, only: %i[show edit update]
<<<<<<< Updated upstream
  before_action :set_active_inns, only: %i[index search]
  before_action :set_rooms, only: %i[show]
  before_action :block_customers, only: %i[new create edit]
  before_action :block_owners_with_inn, only: %i[new create]
=======
  before_action :set_active_inns, only: %i[index search adv_search]

  before_action :inn_exists?, only: %i[new create]
  before_action only: %i[edit update] do
    redirect_to(root_path) unless the_owner?(@inn)
  end

  before_action :set_rooms, only: %i[show] # NECESSÁRIO?
>>>>>>> Stashed changes

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

  def cities
    @inns_by_city = Inn.all.where('active = 1').order(:city).order(:brand_name).group_by(&:city)
    # @cities_list = @inns_by_city.keys
  end

  def search
    @key = params[:search]
    @active_inns =
      @active_inns.where('brand_name LIKE ? OR city LIKE ? OR zone LIKE ?', "%#{@key}%", "%#{@key}%", "%#{@key}%")
  end

  private

<<<<<<< Updated upstream
  def block_owners_with_inn
    redirect_to inn_path(@inn), notice: 'Sua pousada já está cadastrada.' if @inn
=======
  def inn_exists?
    redirect_to current_user.inn, alert: 'Sua pousada já está cadastrada.' if current_user.inn
>>>>>>> Stashed changes
  end

  def set_inn
    @inn = Inn.find(params[:id])
    check_ownership(@inn)
  end

  def set_active_inns
    @active_inns = Inn.all.where('active = 1').order(:created_at).reverse
    @new_inns = @active_inns.first(3)
    @older_inns = @active_inns - @new_inns if @new_inns
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