# return response into json
# next: pundit
# check if the errors is sent as json and display them to the user
# modifications for devise to work with api without view

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  before_action :update_user_params_with_password, only: :update
  def update
    @user = User.find(current_user.id)
    if (params[:user][:password])
      @user.update_with_password(update_user_params_with_password)
    else
      @user.update_without_password(update_user_params_without_password)
    end
  end

  def create
    super
  end

  private
  def update_user_params_with_password
    params.require(:user).permit(:display_name, :username, :email, :current_password, :password, :password_confirmation)
  end
  def update_user_params_without_password
    params.require(:user).permit(:display_name, :username, :email)
  end
end