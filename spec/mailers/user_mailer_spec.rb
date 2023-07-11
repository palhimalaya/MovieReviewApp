# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Devise::Mailer) do
  describe 'confirmation_instructions' do
    let(:user) { build(:user) }
    let(:token) { SecureRandom.urlsafe_base64.to_s }
    let(:mail) { described_class.confirmation_instructions(user, token, {}) }

    it 'renders the headers' do
      expect(mail.subject).to(eq('Confirmation instructions'))
      expect(mail.to).to(eq([user.email]))
      expect(mail.from).to(eq([ENV['SENDER_EMAIL']]))
    end

    it 'contains the confirmation URL' do
      confirmation_url = "http://localhost:3000/api/v1/users/confirmation?confirmation_token=#{token}"
      expect(mail.body.encoded).to(include(confirmation_url))
    end
  end
end
