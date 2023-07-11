# frozen_string_literal: true

class Api::V1::MoviesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :authorize_admin, except: %i[index show]

  # GET /movies
  def index
    @movies = Movie.all.order(created_at: :desc)
    # return view if not api request
    return if request.format.html?

    render(json: {
      status: { code: 200, message: 'Movies were found successfully.' },
      data: ActiveModel::SerializableResource.new(@movies, each_serializer: MovieSerializer)
    }, status: :ok
    )
  end

  # GET /movies/1
  def show
    @movie = Movie.find(params[:id])
    return if request.format.html?

    render(json: {
      status: { code: 200, message: 'Movie was found successfully.' },
      data: ActiveModel::SerializableResource.new(@movie, each_serializer: MovieSerializer)
    }, status: :ok
    )
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
    # binding.pry
    if @movie.save
      flash[:notice] = 'Movie was added successfully!'
      return redirect_to(root_path) if request.format.html?

      render(json: {
               status: { code: 201, message: 'Movie was created successfully.' },
               data: ActiveModel::SerializableResource.new(@movie, each_serializer: MovieSerializer)
             },
             status: :created
            )

    else
      # binding.pry
      flash.now[:alert] = @movie.errors.full_messages.join(', ')

      if request.format.html?
        @form_url = api_v1_movies_path
        render(:new, status: :unprocessable_entity)
      else
        render(json: {
                 status: { code: 422, message: 'Movie was not created successfully.' },
                 data: ActiveModel::SerializableResource.new(@movie, each_serializer: MovieSerializer)
               },
               status: :unprocessable_entity
              )
      end
    end
  end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
    @form_url = api_v1_movie_path(@movie)
  end

  # PATCH/PUT /movies/1
  def update
    @movie = Movie.find(params[:id])
    # binding.pry
    if @movie.update(movie_params)
      # binding.pry
      flash[:notice] = 'Movie was updated successfully!'
      return redirect_to(root_path) if request.format.html?

      render(json: {
        status: { code: 200, message: 'Movie was updated successfully.' },
        data: ActiveModel::SerializableResource.new(@movie, each_serializer: MovieSerializer)

      }, status: :ok
      )
    else
      flash.now[:alert] = @movie.errors.full_messages.join(', ')

      return render(:edit, status: :unprocessable_entity) if request.format.html?

      render(json: {
        status: { code: 422, message: 'Movie was not updated successfully.' },
        data: ActiveModel::SerializableResource.new(@movie, each_serializer: MovieSerializer)
      }, status: :unprocessable_entity
      )
    end
  end

  # DELETE /movies/1
  def destroy
    @movie = Movie.find(params[:id])

    if @movie.destroy
      flash[:notice] = 'Movie was deleted successfully!'
      return redirect_to(root_path) if request.format.html?

      render(json: {
        status: { code: 204, message: 'Movie was deleted successfully.' }
      }
            )
    else
      flash.now[:alert] = @movie.errors.full_messages.join(', ')

      return render(:edit, status: :unprocessable_entity) if request.format.html?

      render(json: {
        status: { code: 422, message: 'Movie was not deleted successfully.' },
        data: ActiveModel::SerializableResource.new(@movie, each_serializer: MovieSerializer)
      }, status: :unprocessable_entity
      )
    end
  end

  private

  def authorize_admin
    return if current_user.role == 'admin'

    if request.format.html?
      (flash[:alert] = 'You do not have permission to perform this action.'
       redirect_to(root_path))
    else
      render(json: {
        status: { code: 401, message: 'You do not have permission to perform this action.' }
      }, status: :unauthorized
      )
    end
  end

  def movie_params
    params.require(:movie).permit(:title, :description, :release_date, :duration, :cover_img)
  end
end
