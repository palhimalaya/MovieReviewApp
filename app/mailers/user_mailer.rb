# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: ENV['SENDER_EMAIL']

  def confirmation_instructions(user, token, *)
    @user = user
    @token = token
    mail(to: @user.email, subject: t('devise.mailer.confirmation_instructions.subject'))
  end
end
