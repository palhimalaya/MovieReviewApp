# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    role { 'audience' }
    password { Faker::Internet.password(min_length: 8) }
    confirmation_token { Faker::Alphanumeric.alphanumeric(number: 10) }
  end
end
