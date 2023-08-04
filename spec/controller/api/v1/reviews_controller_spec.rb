# frozen_string_literal: true

require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe('Review API', type: :request) do
  let(:admin_user) { create(:user, password: 'P@ssw0rd1') }
  let(:audience) { create(:user, role: 'audience', password: 'P@ssw0rd1') }
  let(:headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }
  let(:movie) { create(:movie, user: admin_user) }
  let(:auth_headers) { Devise::JWT::TestHelpers.auth_headers(headers, audience) }

  describe 'GET #index' do
    it 'returns a successful response with JSON data' do
      get "/api/v1/movies/#{movie.id}reviews", headers: { 'ACCEPT' => 'application/json' }
      expect(response).to(be_successful)
      expect(response.content_type).to(include('application/json'))
    end

    it 'returns reviews in JSON format' do
      create(:review, user: audience, movie: movie)
      get "/api/v1/movies/#{movie.id}reviews", headers: { 'ACCEPT' => 'application/json' }
      expect(response).to(be_successful)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['data']['reviews'].length).to(eq(1))
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new review' do
        expect do
          post("/api/v1/movies/#{movie.id}/reviews", params: { review: create(:review, user: audience, movie: movie) }, headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' })
        end.to(change(Review, :count).by(1))
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new review' do
        expect do
          post("/api/v1/movies/#{movie.id}/reviews", params: { review: attributes_for(:review, user: audience, movie: movie, rating: nil) }, headers: auth_headers)
        end.not_to(change(Review, :count))
      end

      it 'returns a 422 response' do
        audience.confirm

        review_attribute = attributes_for(:review, user: audience, movie: movie, rating: nil)
        review_json = JSON.generate({ review: review_attribute })

        post "/api/v1/movies/#{movie.id}/reviews", params: review_json, headers: auth_headers

        expect(response).to(have_http_status(:unprocessable_entity))
      end
    end
  end
end
