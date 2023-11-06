class RoomsController < ApplicationController
  before_action :set_inn, only: %i[new create show update]
  before_action :set_room, only: %i[show edit update]
  before_action :block_customers, only: %i[new create edit]

  def index; end

  def show; end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to @inn, notice: "#{@room.name} foi adicionado com sucesso!"
    else
      flash[:alert] = 'Não foi possível adicionar o quarto.'
      render 'new'
    end
  end

  def edit; end

  def update
    if @room.update(room_params)
      redirect_to @room, notice: "#{@room.name} foi atualizado com sucesso!"
    else
      flash[:alert] = 'Não foi possível atualizar o quarto.'
      render 'edit'
    end
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def set_inn
    @inn = Inn.find_by(user_id: current_user.id)
  end

  def room_params
    params.require(:room).permit(:name, :description, :size, :max_guests, :base_price, :bathroom, :balcony,
                                 :air_conditioning, :tv, :wardrobe, :safe, :accessible, :available, :inn_id)
  end
end
