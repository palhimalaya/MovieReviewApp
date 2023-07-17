# frozen_string_literal: true

class MovieSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :description, :duration, :release_date, :user_id, :cover_img_url, :aggregate_rating

  has_many :reviews

  def cover_img_url
    object.cover_img.url if object.cover_img.attached?
  end
end
