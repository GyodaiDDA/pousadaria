class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: %i[create]
  before_action :configure_update_params, only: %i[edit_document update_document]

  def edit_document
    @resource = current_user
  end

  def update_document
    @resource = current_user
    if @resource.update(document_params)
      redirect_to request.referer, notice: 'Seu cadastrado foi atualizado.'
    else
      flash[:notice] = 'Não foi possível atualizar seu cadastro.'
      render edit_document
    end
  end

  private

  def document_params
    params.require(:Customer).permit(:full_name, :document)
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
