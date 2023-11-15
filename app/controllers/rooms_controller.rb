class RoomsController < ApplicationController
  before_action :set_room, only: %i[show edit update]
  before_action only: %i[new create edit update] do
    the_owner?(current_user.inn)
  end

  def index
    @rooms = Room.all
  end

  def show; end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to @room, notice: "#{@room.name} foi adicionado com sucesso!"
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

  def available?
    
  end

  private

  def set_room 
    @room = Room.find(params[:id])
    @owner_view = the_owner?(@room.inn)
  end

  def room_params
    params.require(:room)
          .permit(:name, :description, :size, :max_guests, :base_price, :bathroom, :balcony,
                  :air_conditioning, :tv, :wardrobe, :safe, :accessible, :available, :inn_id)
  end
end
