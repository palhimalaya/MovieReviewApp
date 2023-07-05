# frozen_string_literal: true

class Api::V1::ReviewsController < ApplicationController
  def index
    @reviews = Review.all.order(created_at: :desc)
    render(json: @reviews)
  end

  def show
    @review = Review.find(params[:id])
    render(json: @review)
  end

  def new
    @review = Review.new
    @form_url = api_v1_reviews_path
  end
end
