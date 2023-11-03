class InnsController < ApplicationController
  def index
    @inns = Inn.all
  end

  def show
    @inn = Inn.find(params[:id])
  end

  def new
    @inn = Inn.new
  end
end
