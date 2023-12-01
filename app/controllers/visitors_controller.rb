class VisitorsController < ApplicationController
  before_action :set_reservation, only: %i[new create]

  def new
    @visitor = Visitor.new
  end

  def create
    @visitor = Visitor.new(visitor_params)
    if @visitor.save
      redirect_to request.referer, notice: 'Hóspede registrado com sucesso'
    else
      redirect_to request.referer, notice: 'Não foi possível registrar este hóspede'
    end
    @reservation.update({ status: 'registered' }) if @reservation.visitors.size == @reservation.guests
  end

  private

  def set_reservation
    @reservation = Reservation.find_by(id: params[:reservation_id])
  end

  def visitor_params
    params.require(:visitor)
          .permit(:full_name, :document, :email, :reservation_id)
  end
end
