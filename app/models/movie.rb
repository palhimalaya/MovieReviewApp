# frozen_string_literal: true

require 'csv'

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

  def self.to_csv
    movies = all
    CSV.generate do |csv|
      csv << %w[id name aggregate_review]
      movies.each do |movie|
        csv << [movie.id, movie.title, movie.aggregate_rating]
      end
    end
  end
end
