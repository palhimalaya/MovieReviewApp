# frozen_string_literal: true

FactoryBot.define do
  factory :movie do
    title { 'MyString' }
    description { 'MyString' }
    release_date { '2023-06-29' }
    duration { 1 }
    cover_img { 'MyString' }
  end
end
