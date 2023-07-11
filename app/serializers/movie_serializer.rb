# frozen_string_literal: true

class MovieSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :duration, :release_date, :user_id, :aggregate_rating

  has_many :reviews
end
