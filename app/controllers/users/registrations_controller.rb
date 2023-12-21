# return response into json
# check if the errors is sent as json and display them to the user
# modifications for devise to work with api without view

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  before_action :update_user_params, only: :update
  before_action :authenticate_user!, only: :update

  def update
    authorize params[:user][:id], policy_class: UserPolicy
    uploader = AvatarUploader.new
    uploader.store!(params[:user])
    if (params[:user][:password])
      if @user.update_with_password(update_user_params_with_password)
        head :no_content
      else
        render json: { errors: @user.errors }, status: :unprocessable_entity
      end
    else
      if @user.update_without_password(update_user_params_without_password)
        head :no_content
      else 
        render json: { errors: @user.errors }, status: :unprocessable_entity
      end
    end
  end

  def create
    super
  end

  private
  def update_user_params
    params.require(:user).permit(:id, :display_name, :avatar, :username, :email, :current_password, :password, :password_confirmation)
  end
  def update_user_params_with_password
    params.require(:user).permit(:id, :display_name, :avatar, :username, :email, :current_password, :password, :password_confirmation)
  end
  def update_user_params_without_password
    params.require(:user).permit(:id,:avatar, :display_name, :username, :email)
  end
end