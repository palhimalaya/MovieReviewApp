# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe(Movie(API, type: :request)) do
  path '/api/v1/movies' do
    get 'Get a list of movies' do
      tags 'Movies'
      produces 'application/json'

      response '200', 'successful' do
        examples 'application/json' => {
          movies: [
            {
              id: 1,
              title: 'The Matrix',
              description: 'Movie Description',
              release_date: '1999-03-31',
              duration: 120,
              user_id: 1,
              cover_img: 'http://res.cloudinary.com/dtghv3ml5/image/upload/jzwaqy0pegzl8kx0jxmd6g4sht2t.png',
              aggregate_rating: 4.0,
              reviews: [
                {
                  id: 2,
                  movie_id: 1,
                  user_id: 6,
                  rating: 4,
                  review: 'string',
                  created_at: '2023-07-16T12:38:29.262Z',
                  updated_at: '2023-07-16T12:38:29.262Z'
                }
              ]
            }
          ]
        }

        run_test!
      end
    end

    post 'Create a new movie' do
      tags 'Movies'
      consumes 'multipart/form-data'
      produces 'application/json'
      parameter name: :movie, in: :formData, type: :object, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          release_date: { type: :string, format: :date },
          duration: { type: :integer },
          cover_img: { type: :string, format: :binary }
        },
        required: %w[title release_date duration cover_img]
      }

      response '201', 'Movie created successfully' do
        examples 'application/json' => {
          movie: {
            id: 1,
            title: 'The Matrix',
            description: 'Movie Description',
            release_date: '1999-03-31',
            duration: 120,
            user_id: 1,
            cover_img: 'http://res.cloudinary.com/dtghv3ml5/image/upload/jzwaqy0pegzl8kx0jxmd6g4sht2t.png',
            aggregate_rating: 4.0,
            reviews: [
              {
                id: 2,
                movie_id: 1,
                user_id: 6,
                rating: 4,
                review: 'string',
                created_at: '2023-07-16T12:38:29.262Z',
                updated_at: '2023-07-16T12:38:29.262Z'
              }
            ]
          }
        }

        run_test!
      end

      response '422', 'Unprocessable Entity' do
        examples 'application/json' => {
          status: {
            code: 422,
            message: 'Invalid Movie'
          }
        }
        run_test!
      end
    end
  end

  path '/api/v1/movies/{id}' do
    get 'Fetch details of a movie' do
      tags 'Movies'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'successful' do
        examples 'application/json' => {
          movie: {
            id: 1,
            title: 'The Matrix',
            description: 'Movie Description',
            release_date: '1999-03-31',
            duration: 120,
            user_id: 1,
            cover_img: 'http://res.cloudinary.com/dtghv3ml5/image/upload/jzwaqy0pegzl8kx0jxmd6g4sht2t.png',
            aggregate_rating: 4.0,
            reviews: [
              {
                id: 2,
                movie_id: 1,
                user_id: 6,
                rating: 4,
                review: 'string',
                created_at: '2023-07-16T12:38:29.262Z',
                updated_at: '2023-07-16T12:38:29.262Z'
              }
            ]
          }
        }

        run_test!
      end

      response '403', 'Forbidden' do
        examples 'application/json' => {
          status: {
            code: 403,
            message: 'You need to sign in or sign up before continuing.'
          }
        }
        run_test!
      end

      response '404', 'Not Found' do
        examples 'application/json' => {
          status: {
            code: 404,
            message: 'Movie not found'
          }
        }
        run_test!
      end
    end

    patch 'Updates a movie' do
      tags 'Movies'
      consumes 'multipart/form-data'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :movie, in: :formData, type: :object, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          release_date: { type: :string, format: :date },
          duration: { type: :integer },
          cover_img: { type: :string, format: :binary }
        },
        required: %w[title release_date duration cover_img]
      }

      response '200', 'Movie updated successfully' do
        examples 'application/json' => {
          movie: {
            id: 1,
            title: 'The Matrix',
            description: 'Movie Description',
            release_date: '1999-03-31',
            duration: 120,
            user_id: 1,
            cover_img: 'http://res.cloudinary.com/dtghv3ml5/image/upload/jzwaqy0pegzl8kx0jxmd6g4sht2t.png',
            aggregate_rating: 4.0,
            reviews: [
              {
                id: 2,
                movie_id: 1,
                user_id: 6,
                rating: 4,
                review: 'string',
                created_at: '2023-07-16T12:38:29.262Z',
                updated_at: '2023-07-16T12:38:29.262Z'
              }
            ]
          }
        }

        run_test!
      end

      response '404', 'Not Found' do
        examples 'application/json' => {
          status: {
            code: 404,
            message: 'Movie not found'
          }

        }

        run_test!
      end

      response '422', 'Unprocessable Entity' do
        examples 'application/json' => {
          status: {
            code: 422,
            message: 'Invalid Movie'
          }
        }
        run_test!
      end
    end

    delete 'Deletes a movie' do
      tags 'Movies'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'Movie deleted successfully' do
        examples 'application/json' => {
          status: {
            code: 200,
            message: 'Movie deleted successfully'
          }
        }

        run_test!
      end

      response '404', 'Not Found' do
        examples 'application/json' => {
          status: {
            code: 404,
            message: 'Movie not found'
          }
        }
        run_test!
      end
    end
  end
end
