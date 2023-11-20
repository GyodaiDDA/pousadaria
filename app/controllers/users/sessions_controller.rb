class Users::SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    if resource.user_type == 'Owner'
      after_owner_sign_in
    elsif resource.user_type == 'Customer'
      after_customer_sign_in
    end
  end

  def after_owner_sign_in
    if resource.inn.blank?
      new_inn_path
    else
      inn_path(current_user.inn)
    end
  end

  def after_customer_sign_in
    if params[:caught]
      stored_location_for(resource) || request.referer || root_path
    elsif session[:codes]
      reservations_retrieve_path
    else
      root_path
    end
  end
end
