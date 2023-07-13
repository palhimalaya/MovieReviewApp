# frozen_string_literal: true

class MovieSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :description, :duration, :release_date, :user_id, :cover_img, :aggregate_rating

  has_many :reviews

  # def cover_img_url
  #   rails_blob_path(object.cover_img, only_path: true) if object.cover_img.attached?
  # end
end
