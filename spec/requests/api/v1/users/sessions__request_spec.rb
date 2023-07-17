# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe('api/v1/sessions', type: :request) do
  path '/api/v1/users/login' do
    post('create session') do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string }
            }
          }
        },
        required: %w[email password]
      }

      response(200, 'Success') do
        examples 'application/json' => {
          status: {
            code: 200,
            message: 'Logged in sucessfully.'
          }
        }
        run_test!
      end

      response(422, 'Unprocessable Entity') do
        examples 'application/json' => {
          status: {
            message: 'Invalid Email or password.'
          }
        }
        run_test!
      end
    end
  end
end
