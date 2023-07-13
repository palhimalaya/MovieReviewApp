# frozen_string_literal: true

module Movies
  class Find
    attr_reader :scope, :search_query, :sort_by

    def initialize(scope, params)
      @scope = scope
      @search_query = params[:search]
      @sort_by = params[:order]
    end

    def execute
      return scope if search_query.blank? && sort_by.blank?

      movies = search_by_name(scope)
      sort_by_release_date(movies)
    end

    private

    def search_by_name(scope)
      scope.where('LOWER(title) LIKE LOWER(?)', "%#{search_query.to_s.downcase}%")
    end

    def sort_by_release_date(movies)
      return movies if sort_by.blank?

      movies.order(release_date: sort_by)
    end
  end
end
