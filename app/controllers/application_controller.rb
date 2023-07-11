# frozen_string_literal: true

# ApplicationController class
class ApplicationController < ActionController::Base
  include Pundit::Authorization
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?

  respond_to :html, :json

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:role, :first_name, :last_name, :email, :password, :password_confirmation)
    end
  end
end
