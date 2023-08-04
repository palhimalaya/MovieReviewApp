# frozen_string_literal: true

require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe('Movie API', type: :request) do
  let(:admin_user) { create(:user, password: 'P@ssw0rd1') }
  let(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }
  let(:auth_headers) { Devise::JWT::TestHelpers.auth_headers(headers, admin_user) }

  describe 'GET #index' do
    it 'returns a successful response with JSON data' do
      get '/api/v1/movies', headers: { 'ACCEPT' => 'application/json' }
      expect(response).to(be_successful)
      expect(response.content_type).to(include('application/json'))
    end

    it 'returns movies in JSON format' do
      admin_user = build(:user, password: 'P@ssw0rd1')
      create(:movie, user: admin_user)
      create(:movie, user: admin_user)

      get '/api/v1/movies', headers: { 'ACCEPT' => 'application/json' }
      expect(response).to(be_successful)
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['data'].length).to(eq(2))
    end
  end

  describe 'GET #show' do
    it 'returns a successful response with JSON data' do
      admin_user = build(:user, password: 'P@ssw0rd1')
      movie = create(:movie, user: admin_user)

      get "/api/v1/movies/#{movie.id}", headers: { 'ACCEPT' => 'application/json' }
      expect(response).to(be_successful)
      expect(response.content_type).to(include('application/json'))
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new movie' do
        expect do
          post('/api/v1/movies', params: { movie: create(:movie, user: admin_user) }, headers: auth_headers)
        end.to(change(Movie, :count).by(1))
      end

      it 'returns a successful response with JSON data' do
        admin_user.confirm
        movie_attributes = attributes_for(:movie, user: admin_user)

        post '/api/v1/movies', params: movie_attributes.to_json, headers: auth_headers

        expect(response).to(have_http_status(:created))
      end

      it 'check total number of records created' do
        admin_user.confirm
        movie_attributes = attributes_for(:movie, user: admin_user)

        post '/api/v1/movies', params: movie_attributes.to_json, headers: auth_headers

        expect(Movie.count).to(eq(1))
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new movie' do
        expect do
          post('/api/v1/movies', params: { movie: attributes_for(:movie, title: '') }, headers: { 'ACCEPT' => 'application/json' })
        end.not_to(change(Movie, :count))
      end

      it 'returns an unprocessable entity response' do
        admin_user.confirm
        post('/api/v1/movies', params: { movie: attributes_for(:movie, title: '') }, headers: auth_headers)
        expect(response).to(have_http_status(:unprocessable_entity))
      end

      it 'returns an error message' do
        admin_user.confirm
        post('/api/v1/movies', params: { movie: attributes_for(:movie, title: '') }, headers: auth_headers)
        expect(response.body).to(include('Movie was not created.'))
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      it 'updates a movie' do
        admin_user.confirm
        movie = create(:movie, user: admin_user)

        put "/api/v1/movies/#{movie.id}", params: { movie: { title: 'Updated Title' } }.to_json, headers: auth_headers
        expect(response).to(have_http_status(:ok))
      end
    end

    context 'with invalid attributes' do
      it 'does not update a movie' do
        admin_user.confirm
        movie = create(:movie, user: admin_user)
        movie_attributes = attributes_for(:movie, title: '')

        put "/api/v1/movies/#{movie.id}", params: movie_attributes.to_json, headers: auth_headers

        expect(response).to(have_http_status(:unprocessable_entity))
      end

      it 'returns an error message' do
        admin_user.confirm
        movie = create(:movie, user: admin_user)
        movie_attributes = attributes_for(:movie, title: '')

        put "/api/v1/movies/#{movie.id}", params: movie_attributes.to_json, headers: auth_headers

        expect(response.body).to(include('Movie was not updated.'))
      end
    end

    context 'when the movie does not exist' do
      it 'returns not_found response' do
        admin_user.confirm
        put('/api/v1/movies/0', params: { movie: { title: 'Updated Title' } }.to_json, headers: auth_headers)
        expect(response).to(have_http_status(:not_found))
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes a movie' do
      admin_user.confirm
      movie = create(:movie, user: admin_user)

      expect do
        delete("/api/v1/movies/#{movie.id}", headers: auth_headers)
      end.to(change(Movie, :count).by(-1))
    end

    it 'returns not_found response' do
      admin_user.confirm
      delete('/api/v1/movies/0', headers: auth_headers)
      expect(response).to(have_http_status(:not_found))
    end
  end
end
