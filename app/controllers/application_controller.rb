# frozen_string_literal: true

# ApplicationController class
class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  respond_to :html, :json

  def index
    # Set the current_user variable
    @current_user = current_api_v1_users_user
  end
end
