# frozen_string_literal: true

require_relative '../../../finders/movies/find'

# This controller handles API requests related to movies.
class Api::V1::MoviesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :authorize_admin, except: %i[index show]

  # GET /movies
  def index
    @movies = MoviesFinder.new(Movie.all, params).execute
    return if request.format.html?

    render(json: {
      status: {  message: I18n.t('controllers.movies_controller.notice.find_movies') },
      data: ActiveModel::SerializableResource.new(@movies, each_serializer: MovieSerializer)
    }, status: :ok
    )
  end

  # GET /movies/1
  def show
    movie = Movie.find_by(id: params[:id])
    if movie.nil?
      flash[:alert] = I18n.t('controllers.movies_controller.error.find_movie')
      return redirect_to(root_path) if request.format.html?

      render(json: {
        status: { message: I18n.t('controllers.movies_controller.error.find_movie') }
      }, status: :not_found
      )

    else
      @movie = movie
      return if request.format.html?

      render(json: {
        status: { message: I18n.t('controllers.movies_controller.error.find_movie') },
        data: ActiveModel::SerializableResource.new(@movie, each_serializer: MovieSerializer)
      }, status: :ok
      )
    end
  end

  # GET /movies/new
  def new
    @movie = Movie.new
    @form_url = api_v1_movies_path
  end

  # POST /movies
  def create
    @movie = Movie.new(movie_params)
    @movie.user_id = current_user.id
    if @movie.save
      flash[:notice] = I18n.t('controllers.movies_controller.notice.add_movie')
      return redirect_to(root_path) if request.format.html?

      render(json: {
               status: { message: I18n.t('controllers.movies_controller.notice.create') },
               data: ActiveModel::SerializableResource.new(@movie, each_serializer: MovieSerializer)
             },
             status: :created
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
               },
               status: :unprocessable_entity
              )
      end
    end
  end

  # GET /movies/1/edit
  def edit
    @form_url = api_v1_movie_path(movie)
  end

  # PATCH/PUT /movies/1
  def update
    if movie.update(movie_params)

      flash[:notice] = I18n.t('controllers.movies_controller.notice.update_movie')
      return redirect_to(root_path) if request.format.html?

      render(json: {
        status: { message: I18n.t('controllers.movies_controller.notice.update_movie') },
        data: ActiveModel::SerializableResource.new(movie, each_serializer: MovieSerializer)

      }, status: :ok
      )
    else
      flash.now[:alert] = movie.errors.full_messages.join(', ')

      return render(:edit, status: :unprocessable_entity) if request.format.html?

      render(json: {
        status: { message: I18n.t('controllers.movies_controller.error.update_movie') },
        data: ActiveModel::SerializableResource.new(movie, each_serializer: MovieSerializer)
      }, status: :unprocessable_entity
      )
    end
  end

  # DELETE /movies/1
  def destroy
    if movie.destroy
      flash[:notice] = I18n.t('controllers.movies_controller.notice.delete_movie')
      return redirect_to(root_path) if request.format.html?

      render(json: {
        status: { message: I18n.t('controllers.movies_controller.notice.delete_movie') }
      }
            )
    else
      flash.now[:alert] = movie.errors.full_messages.join(', ')

      return render(:edit, status: :unprocessable_entity) if request.format.html?

      render(json: {
        status: { message: I18n.t('controllers.movies_controller.error.delete_movie') },
        data: ActiveModel::SerializableResource.new(movie, each_serializer: MovieSerializer)
      }, status: :unprocessable_entity
      )
    end
  end

  private

  # This method authorizes an admin user to perform certain actions.
  def authorize_admin
    return if current_user.role == 'admin'

    if request.format.html?
      flash[:alert] = I18n.t('controllers.movies_controller.error.unauthorized')
      redirect_to(root_path)
    else
      render(json: {
        status: { message: I18n.t('controllers.movies_controller.error.unauthorized') }
      }, status: :unauthorized
      )
    end
  end

  # This method finds a movie by its ID.
  # Returns: A movie object.
  def movie
    @movie ||= Movie.find(params[:id])
  end

  # This method permits the specified parameters for a movie.
  # Returns: A hash of permitted parameters.
  def movie_params
    params.require(:movie).permit(:title, :description, :release_date, :duration, :cover_img)
  end
end
