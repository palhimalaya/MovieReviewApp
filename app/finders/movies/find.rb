# frozen_string_literal: true

class MoviesFinder
  attr_reader :scope, :params

  def initialize(scope, params)
    @scope = scope
    @params = params
  end

  def execute
    return search if params[:search].present?
    return sort if params[:order].present?

    scope
  end

  private

  def search
    scope.where('title LIKE ?', "%#{params[:search]}%")
  end

  def sort
    scope.order(release_date: params[:order])
  end
end
