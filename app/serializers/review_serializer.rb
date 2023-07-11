# frozen_string_literal: true

class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :movie_id, :user_id, :rating, :review, :created_at, :updated_at
end
