# frozen_string_literal: true

FactoryBot.define do
  factory :movie do
    title { Faker::Movie.title }
    description { Faker::Movie.quote }
    release_date { Faker::Date.between(from: 10.years.ago, to: Time.zone.today) }
    duration { Faker::Number.number(digits: 3) }

    cover_img do
      Rack::Test::UploadedFile.new(
        Rails.root.join('app/assets/images/shawshank.png')
      )
    end
  end
end
