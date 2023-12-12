class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :log_current_user
  # before_action :log_request_headers

  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
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