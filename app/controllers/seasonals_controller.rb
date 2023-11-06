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
    if date_overlap?
      alert_message('O quarto já tem preços especiais no período.', 'new')
    elsif Seasonal.new(seasonal_params).save
      redirect_to @room, notice: 'Período adicionado com sucesso!'
    else
      alert_message('Não foi possível adicionar o período.', 'new')
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

  def date_overlap?
    new_period = params[:start_date]..params[:end_date]
    room_seasonals.each do |p|
      old_period = p.start_date..p.end_date
      return true if new_period.overlaps?(old_period)
    end
  end

  def alert_message(message, screen)
    flash[:alert] = message
    render screen.to_s
  end
end
