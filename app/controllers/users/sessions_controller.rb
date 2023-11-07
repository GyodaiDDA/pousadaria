class Users::SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    if resource.user_type == 'Owner' && resource.inn.blank?
      new_inn_path
    else
      inn_path(Inn.find_by(user_id: current_user.id))
    end
  end
end
