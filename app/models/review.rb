# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :rating, presence: true, numericality: { greater_than: 0, less_than: 11 }
  validates :review, presence: true
end
