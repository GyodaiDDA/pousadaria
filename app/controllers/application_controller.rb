class ApplicationController < ActionController::Base
  before_action :set_locale

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def the_owner?(inn)
    return unless user_signed_in?
    return unless current_user.user_type == 'Owner'

    current_user.id == inn.user_id
  end

  def cpf?
    return if current_user.user_type == 'Owner'
    return unless current_user.document.nil?

    redirect_to edit_customer_document_path, notice: 'Você precisa completar seus dados com nome e CPF para poder prosseguir.'
  end
end
