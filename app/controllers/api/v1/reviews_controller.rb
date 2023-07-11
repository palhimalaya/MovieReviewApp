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
    @form_url = api_v1_movie_reviews_path
  end

  def create
    @movie = Movie.find(params[:movie_id])
    @review = @movie.reviews.build(review_params)
    @review.user_id = current_user.id

    if @review.save
      flash[:notice] = 'Review was added successfully!'
      return redirect_to(api_v1_movie_path(@movie)) if request.format.html?

      render(json: {
               status: { code: 201, message: 'Review was created successfully.' },
               data: ActiveModel::SerializableResource.new(@review, each_serializer: ReviewSerializer)
             },
             status: :created
            )
    else
      flash.now[:alert] = @review.errors.full_messages.join(', ')

      if request.format.html?
        @form_url = api_v1_movie_reviews_path
        render(:new, status: :unprocessable_entity)
      else
        render(json: {
                 status: { code: 422, message: 'Review was not created.' },
                 errors: @review.errors.full_messages
               },
               status: :unprocessable_entity
              )
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :review)
  end
end
