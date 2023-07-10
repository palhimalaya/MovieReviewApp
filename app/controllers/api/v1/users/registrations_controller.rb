# frozen_string_literal: true

class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  # GET /resource/sign_up
  # def new
  #   super
  # end
  # POST /resource
  # def create
  #   super
  # end
  # GET /resource/edit
  # def edit
  #   super
  # end
  # PUT /resource
  # def update
  #   super
  # end
  # DELETE /resource
  # def destroy
  #   super
  # end
  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
  # end
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end
  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end
  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private

  def respond_with(resource, _opts = {})
    return super if request.format.html?

    if request.method == 'POST' && resource.persisted?
      render(json: {
        status: {  message: I18n.t('controllers.users_controller.notice.create') },
        data: ActiveModel::SerializableResource.new(resource, each_serializer: UserSerializer)
      }, status: :ok
      )
    elsif request.method == 'DELETE'
      render(json: {
        status: { message: I18n.t('controllers.users_controller.notice.delete_user') }
      }, status: :ok
      )
    else
      render(json: {
        status: {  message: "#{I18.t('controllers.users_controller.error.create')} #{resource.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
      )
    end
  end
end
