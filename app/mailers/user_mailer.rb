# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: 'your-email@example.com'

  def confirmation_instructions(user, token, *)
    @user = user
    @token = token
    mail(to: @user.email, subject: 'Confirmation Instructions')
  end
end
