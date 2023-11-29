class HomeController < ApplicationController
  def index
    @active_inns = Inn.where(active: true).order(:created_at).reverse
    @new_inns = @active_inns.first(3)
    @older_inns = @active_inns - @new_inns if @new_inns
  end
end
