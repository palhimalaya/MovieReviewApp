# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Registration API', type: :request) do
  describe 'POST /api/v1/users' do
    context 'with valid attributes' do
      it 'creates a new user' do
        user_attributes = attributes_for(:user, email: 'example1@gmail.com', password: 'P@ssw0rd1')
        post '/api/v1/users', params: { user: user_attributes }, headers: { 'ACCEPT' => 'application/json' }

        expect(response).to(have_http_status(:created))
        expect(response.content_type).to(include('application/json'))
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new user' do
        user_attributes = attributes_for(:user, email: '', password: 'weakpassword')
        post '/api/v1/users', params: { user: user_attributes }, headers: { 'ACCEPT' => 'application/json' }

        expect(response).to(have_http_status(:unprocessable_entity))
      end
    end
  end
end
