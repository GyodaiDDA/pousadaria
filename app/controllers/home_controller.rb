class HomeController < ApplicationController
  def index
    @active_inns = Inn.all.select { |inn| inn.active == true }
  end
end
