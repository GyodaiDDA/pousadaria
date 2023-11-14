class HomeController < ApplicationController
  def index
    def set_active_inns
      @active_inns = Inn.all.where('active = 1').order(:created_at).reverse
      @new_inns = @active_inns.first(3)
      @older_inns = @active_inns - @new_inns if @new_inns
    end
  end
end
