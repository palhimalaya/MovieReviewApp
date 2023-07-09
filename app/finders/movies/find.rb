# frozen_string_literal: true

class MoviesFinder
  def initialize(params)
    @params = params
  end

  def search
    Movie.where('title LIKE ?', "%#{@params[:search]}%")
  end

  def sort
    Movie.order(release_date: @params[:order])
  end

  def find_movies
    movies = Movie.all

    movies = search if @params[:search].present?
    movies = sort if @params[:order].present?

    movies
  end
end
