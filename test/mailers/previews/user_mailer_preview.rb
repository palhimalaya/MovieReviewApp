# frozen_string_literal: true

require 'securerandom'

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    UserMailer.confirmation_instructions(User.first, SecureRandom.hex(13), {})
  end
end
