class ApplicationController < ActionController::Base
  before_action :set_locale

  private

  def clean_session_codes
    return unless session[:codes]

    valid_codes = Reservation.where('status = ? AND created_at > ?', 'available', Time.zone.now - 48.hours).pluck(:code)
    session[:codes].delete_if { |code| !valid_codes.include?(code) }
    session[:codes]
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def the_owner?(inn)
    return unless user_signed_in?
    return unless current_user.user_type == 'Owner'

    current_user.id == inn.user_id
  end

  def cpf?
    return unless user_signed_in?

    redirect_to new_user_session_path, notice: 'Você precisa estar logado para poder continuar.'
    return unless current_user.document.nil?

    redirect_to edit_customer_document_path, notice: 'Você precisa completar seus dados com nome e CPF para poder prosseguir.'
  end
end
