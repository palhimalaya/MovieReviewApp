# frozen_string_literal: true

class MovieSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :duration, :release_date, :created_at, :updated_at, :user_id
  has_many :reviews
end
