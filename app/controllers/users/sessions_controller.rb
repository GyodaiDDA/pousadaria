class Users::SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    if resource.type == 'Owner' && resource.inn.blank?
      new_inn_path
    else
      root_path
    end
  end
end
