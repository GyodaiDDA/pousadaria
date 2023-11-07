class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_type])
  end

  def after_sign_up_path_for(resource)
    if resource.user_type == 'Owner' && resource.inn.blank?
      new_inn_path
    else
      new_session_path
    end
  end
end
