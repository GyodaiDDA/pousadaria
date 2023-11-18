class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: %i[create]
  before_action :configure_update_params, only: %i[document_edit document_update]

  def document_edit
    @user = current_user
  end

  def document_update
    @user = current_user
    if @user.update(document_params)
      redirect_to request.referer, notice: 'Seus dados foram cadastrados'
    else
      flash[:notice] = 'Não foi possível cadastrar os dados'
      render document_edit
    end
  end

  private

  def document_params
    params.require(:user).permit(:full_name, :cpf)
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_type])
  end

  def configure_update_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:document])
  end

  def after_sign_up_path_for(resource)
    if resource.user_type == 'Owner' && resource.inn.blank?
      new_inn_path
    else
      root_path
    end
  end
end
