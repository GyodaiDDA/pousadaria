class User::SessionsController < Devise::SessionsController
  before_action :check_user_type, only: [:create]

  private

  def check_user_type
    user = User.find_by(email: params[:user][:email])

    return unless user && user.type != params[:user][:type]

    redirect_to new_user_session_path, alert: "Você não pode fazer login como #{user.type}."
  end
end
