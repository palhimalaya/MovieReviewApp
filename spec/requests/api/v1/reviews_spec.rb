# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe('API::V1::Reviews', type: :request) do
  path '/api/v1/movies/{movie_id}/' do
    parameter name: :movie_id, in: :path, type: :integer, required: true

    get 'Get all reviews for a specific movie' do
      tags 'Reviews'
      produces 'application/json'

      response '200', 'Reviews found' do
        let(:movie_id) { 5 }
        run_test!
      end

      response '404', 'Movie not found' do
        let(:movie_id) { 999 }
        run_test!
      end
    end
  end
  path '/api/v1/movies/{movie_id}/reviews' do
    parameter name: :movie_id, in: :path, type: :integer, required: true
    post 'Create a new review' do
      tags 'Reviews'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :review, in: :body, schema: {
        type: :object,
        properties: {
          review: {
            type: :object,
            properties: {
              rating: { type: :integer },
              review: { type: :string }
            }
          }
        },
        required: %w[rating review]
      }

      response '201', 'Review created successfully' do
        examples 'application/json' => {
          id: 3,
          rating: 4,
          review: 'Enjoyed the movie!',
          created_at: '2023-07-18T12:45:00Z',
          updated_at: '2023-07-18T12:45:00Z'
        }
        run_test!
      end

      response '422', 'Unprocessable Entity' do
        examples 'application/json' => {
          status: {
            code: 422,
            message: 'Invalid Review'
          }
        }
        run_test!
      end
    end
  end
end
