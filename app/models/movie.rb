# frozen_string_literal: true

class Movie < ApplicationRecord
  belongs_to :user
  has_many :reviews, dependent: :destroy

  has_one_attached :cover_img,  dependent: :destroy do |attachable|
    attachable.variant(:thumb, resize_to_limit: [500, 500])
  end

  validates :title, presence: true
  validates :release_date, presence: true
  validates :duration, presence: true

  def aggregate_rating
    return 0 if reviews.empty?

    Float(reviews.average(:rating)).round(2)
  end
end
