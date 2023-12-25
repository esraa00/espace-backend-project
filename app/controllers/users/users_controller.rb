class Users::UsersController < ApplicationController
  respond_to :json
  before_action :authenticate_user!

  def show
    authorize params[:id], policy_class: UserPolicy
    @user = User.find(params[:id])
    @serialized_user = UserSerializer.new(@user).serializable_hash[:data][:attributes]
    render json: { user: @serialized_user }
  end
end