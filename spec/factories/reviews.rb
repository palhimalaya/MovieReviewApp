# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    rating { Faker::Number.between(from: 1, to: 10) }
    review { Faker::Lorem.paragraph(sentence_count: 2) }
  end
end
