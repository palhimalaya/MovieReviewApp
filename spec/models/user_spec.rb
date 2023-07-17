# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(User, type: :model) do
  let(:user) { build(:user) }

  it 'sends confirmation email to a registered user' do
    expect { user.send_instructions(user.confirmation_token) }
      .to(change { ActionMailer::Base.deliveries.count }.by(1))
  end

  it 'validates presence of first name' do
    expect(user).to(validate_presence_of(:first_name))
  end

  it 'validates presence of last name' do
    expect(user).to(validate_presence_of(:last_name))
  end

  it 'validates presence of email' do
    expect(user).to(validate_presence_of(:email))
  end

  it 'validates presence of password' do
    expect(user).to(validate_presence_of(:password))
  end

  it 'validates presence of role' do
    expect(user).to(validate_presence_of(:role))
  end

  it 'validates password pattern' do
    expect(user).to(allow_value('Password1!').for(:password))

    expect(user).not_to(allow_value('password1!').for(:password))
    expect(user).not_to(allow_value('PASSWORD1!').for(:password))
    expect(user).not_to(allow_value('Password!').for(:password))
    expect(user).not_to(allow_value('Password1').for(:password))
    expect(user).not_to(allow_value('Password').for(:password))
    expect(user).not_to(allow_value('12345678').for(:password))
    expect(user).not_to(allow_value('!@#$%^&*').for(:password))
    expect(user).not_to(allow_value('Pass1!').for(:password))
  end
end
