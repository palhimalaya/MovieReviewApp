# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe('User Registration API', type: :request) do
  path '/api/v1/users/' do
    post 'Register a new user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              first_name: { type: :string },
              last_name: { type: :string },
              email: { type: :string, format: :email },
              password: { type: :string },
              password_confirmation: { type: :string }
            },
            required: %w[first_name last_name email password password_confirmation]
          }
        }
      }

      response '201', 'User registered successfully' do
        examples 'application/json' => {
          user: {
            id: 1,
            first_name: 'John',
            last_name: 'Doe',
            email: 'john.doe@example.com'
          }
        }

        run_test!
      end

      response '403', 'Forbidden' do
        examples 'application/json' => {
          error: {
            code: 403,
            message: 'Forbidden'
          }
        }
      end

      response '422', 'Unprocessable Entity' do
        examples 'application/json' => {
          error: {
            code: 422,
            message: 'Unprocessable Entity',
            fields: {
              first_name: ['First name cannot be blank'],
              email: ['Email must be valid', 'Email has already been taken']
            }
          }
        }

        run_test!
      end
    end
  end
end
