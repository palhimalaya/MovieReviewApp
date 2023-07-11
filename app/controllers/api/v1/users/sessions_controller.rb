# frozen_string_literal: true

class Api::V1::Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def respond_with(resource, _opts = {})
    return super if request.format.html?

    render(json: {
      status: { message: I18n.t('controllers.users_controller.notice.sign_in') },
      data: ActiveModelSerializers::SerializableResource.new(resource, each_serializer: UserSerializer)
    }, status: :ok
    )
  end

  def respond_to_on_destroy
    return super if request.format.html?

    if current_user
      render(json: {
        message: I18n.t('controllers.users_controller.notice.sign_out')
      }, status: :ok
      )
    else
      render(json: {
        message: I18n.t('controllers.users_controller.error.sign_out')
      }, status: :unauthorized
      )
    end
  end
end
