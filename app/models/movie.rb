# frozen_string_literal: true

class Movie < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :release_date, presence: true
  validates :duration, presence: true
end
