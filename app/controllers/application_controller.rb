class ApplicationController < ActionController::Base
  before_action :set_locale

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def block_customers
    return unless current_user

    redirect_to root_path, notice: 'Página inacessível' unless current_user.user_type == 'Owner'
  end
end
