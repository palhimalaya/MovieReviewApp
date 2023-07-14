# frozen_string_literal: true

# This controller handles API requests related to movies.
class Api::V1::MoviesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_movie, only: %i[show edit update destroy]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /movies
  def index
    @movies = Movies::Find.new(Movie.all, params).execute

    return if request.format.html?

    # send csv if requested by client
    if params[:format] == 'csv'
      send_data(@movies.to_csv, filename: "movies-#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.csv")
    else
      render(json: {
        status: { message: I18n.t('controllers.movies_controller.notice.find_movies') },
        data: ActiveModel::SerializableResource.new(@movies, each_serializer: MovieSerializer)
      }, status: :ok
      )
    end
  end

  # GET /movies/1
  def show
    return if request.format.html?

    render(json: {
      status: { message: I18n.t('controllers.movies_controller.notice.find_movie') },
      data: ActiveModel::SerializableResource.new(@movie, each_serializer: MovieSerializer)
    }, status: :ok
    )
  end

  # GET /movies/new
  def new
    authorize(Movie)
    @movie = Movie.new
    @form_url = api_v1_movies_path
  end

  # POST /movies
  def create
    authorize(Movie)
    @movie = Movie.new(movie_params)
    @movie.user_id = current_user.id

    if @movie.save
      flash[:notice] = I18n.t('controllers.movies_controller.notice.add_movie')
      return redirect_to(root_path) if request.format.html?

      render(json: {
        status: { message: I18n.t('controllers.movies_controller.notice.create') },
        data: ActiveModel::SerializableResource.new(@movie, each_serializer: MovieSerializer)
      }, status: :created
      )
    else
      flash.now[:alert] = @movie.errors.full_messages.join(', ')

      if request.format.html?
        @form_url = api_v1_movies_path
        render(:new, status: :unprocessable_entity)
      else
        render(json: {
          status: { message: I18n.t('controllers.movies_controller.error.create') },
          data: ActiveModel::SerializableResource.new(@movie, each_serializer: MovieSerializer)
        }, status: :unprocessable_entity
        )
      end
    end
  end

  # GET /movies/1/edit
  def edit
    authorize(@movie)
    @form_url = api_v1_movie_path(@movie)
  end

  # PATCH/PUT /movies/1
  def update
    authorize(@movie)
    if @movie.update(movie_params)
      flash[:notice] = I18n.t('controllers.movies_controller.notice.update_movie')
      return redirect_to(root_path) if request.format.html?

      render(json: {
        status: { message: I18n.t('controllers.movies_controller.notice.update_movie') },
        data: ActiveModel::SerializableResource.new(@movie, each_serializer: MovieSerializer)
      }, status: :ok
      )
    else
      flash.now[:alert] = @movie.errors.full_messages.join(', ')

      if request.format.html?
        @form_url = api_v1_movie_path(@movie)
        render(:edit, status: :unprocessable_entity)
      else
        render(json: {
          status: { message: I18n.t('controllers.movies_controller.error.update_movie') },
          data: ActiveModel::SerializableResource.new(@movie, each_serializer: MovieSerializer)
        }, status: :unprocessable_entity
        )
      end
    end
  end

  # DELETE /movies/1
  def destroy
    authorize(@movie)
    if @movie.destroy
      flash[:notice] = I18n.t('controllers.movies_controller.notice.delete_movie')
      return redirect_to(root_path) if request.format.html?

      render(json: {
        status: { message: I18n.t('controllers.movies_controller.notice.delete_movie') }
      }
            )
    else
      flash.now[:alert] = @movie.errors.full_messages.join(', ')

      if request.format.html?
        render(:edit, status: :unprocessable_entity)
      else
        render(json: {
          status: { message: I18n.t('controllers.movies_controller.error.delete_movie') },
          data: ActiveModel::SerializableResource.new(@movie, each_serializer: MovieSerializer)
        }, status: :unprocessable_entity
        )
      end
    end
  end

  private

  def user_not_authorized
    if request.format.html?
      flash[:alert] = 'You are not authorized to perform this action.'
      redirect_to(root_path)
    else
      render(json: { error: 'You are not authorized to perform this action.' }, status: :unauthorized)
    end
  end

  # This method finds a movie by its ID.
  def set_movie
    @movie ||= Movie.find_by(id: params[:id])

    alert_movie_not_found_error if @movie.blank?
  end

  def alert_movie_not_found_error
    flash[:alert] = I18n.t('controllers.movies_controller.error.find_movie')
    if request.format.html?
      redirect_to(root_path)
    else
      render(json: {
        status: { message: I18n.t('controllers.movies_controller.error.find_movie') }
      }, status: :not_found
      )
    end
  end

  # This method permits the specified parameters for a movie.
  def movie_params
    params.require(:movie).permit(:title, :description, :release_date, :duration, :cover_img)
  end
end
