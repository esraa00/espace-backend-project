class ApplicationController < ActionController::API
  respond_to :json

  include Pundit::Authorization
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :log_current_user
  # before_action :log_request_headers

  protected

  def configure_permitted_parameters
    added_attrs = [:display_name, :username, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: [:id, :display_name, :username, :email,  :current_password, :password, :password_confirmation]
  end

  # def log_current_user
  #   if user_signed_in?
  #     Rails.logger.info "Current User: #{current_user.inspect}"
  #   else
  #     Rails.logger.info "No User Signed In"
  #   end
  # end

  # def log_request_headers
  #   Rails.logger.info "Request Headers: #{request.headers["Authorization"]}"
  # end
end

# 12/12/2023 achievement:
# 1- implemented update user
# 2- managed to read the authorization header in graphql and pass it to REST api(struggled at first with it)
# 3- tried to send the header automatically from the frontend but failed
# 4- tried to make devise to be api only but failed
# 5- tried to return json responses but failed
#
# 13/12/2023
# 1- implemented pundit for edit user route
# 2- tried to override the update user route but couldn't so created a new route instead /users/:id, put method
# 3- try agagin to make devise be api only
# 