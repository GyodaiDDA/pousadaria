class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:type])
  end

  def after_sign_up_path_for(resource)
    if resource.type == 'Owner' && resource.inn.blank?
      new_inn_path
    else
      root_path
    end
  end
end
