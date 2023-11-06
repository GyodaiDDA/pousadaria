class SeasonalsController < ApplicationController
  before_action :set_seasonal, only: %i[show edit update]
  before_action :set_room, only: %i[new create]

  def index
    @seasonals = Seasonal.all
  end

  def show; end

  def new
    @seasonal = Seasonal.new
  end

  def create
    @seasonal = Seasonal.new(seasonal_params)
    if @seasonal.save
      redirect_to @room, notice: 'Período adicionado com sucesso!'
    else
      flash[:alert] = 'Não foi possível adicionar o quarto'
      render 'new'
    end
  end

  def edit; end

  def update; end

  private

  def set_seasonal
    @seasonal = Seasonal.find(params[:id])
  end

  def set_room
    @room = Room.find_by(id: params[:room_id])
  end

  def room_seasonals
    Seasonal.all.select(room_id: params[:room_id])
  end

  def seasonal_params
    params.require(:seasonal)
          .permit(:name, :start_date, :end_date, :special_price, :room_id)
  end
end
