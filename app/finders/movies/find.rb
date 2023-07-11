# frozen_string_literal: true

class MoviesFinder
  attr_reader :scope, :search_query

  def initialize(scope, search_query)
    @scope = scope
    @search_query = search_query
  end

  def execute
    return search_by_name if search_query[:search].present?
    return sort_by_release_date if search_query[:order].present?

    scope
  end

  private

  def search_by_name
    scope.where('title LIKE ?', "%#{search_query[:search]}%")
  end

  def sort_by_release_date
    scope.order(release_date: search_query[:order])
  end
end
