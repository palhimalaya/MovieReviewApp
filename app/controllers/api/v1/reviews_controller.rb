# frozen_string_literal: true

class Api::V1::ReviewsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :authorize_audience, only: %i[new create]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

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
      flash[:notice] = I18n.t('controllers.reviews_controller.notice.add_review')
      return redirect_to(api_v1_movie_path(@movie)) if request.format.html?

      render(json: {
               status: { message: I18n.t('controllers.reviews_controller.notice.create') },
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
                 status: { message: I18n.t('controllers.reviews_controller.error.create') },
                 errors: @review.errors.full_messages
               },
               status: :unprocessable_entity
              )
      end
    end
  end

  private

  def authorize_audience
    authorize(Review)
  end

  def user_not_authorized
    if request.format.html?
      flash[:alert] = 'You are not authorized to perform this action.'
      redirect_to(request.referer || root_path)
    else
      render(json: { error: 'You are not authorized to perform this action.' }, status: :unauthorized)
    end
  end

  def review_params
    params.require(:review).permit(:rating, :review)
  end
end
