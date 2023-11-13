class ApplicationController < ActionController::Base
  before_action :set_locale

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def owners_only
    return false unless user_signed_in?

    current_user.user_type == 'Owner'
  end

  def the_owner?(inn)
    return unless user_signed_in?
    return unless owners_only

    current_user.id == inn.user_id
  end
end
