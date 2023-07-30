# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Api Session', type: :request) do
  include_context 'api request authentication helper methods'
  include_context 'api request global before and after hooks'

  let(:admin_user) { create(:user, password: 'Password1@') }

  context 'Login User' do
    it 'returns a successful response with JSON data' do
      admin_user.confirm
      post '/api/v1/users/login', params: { user: { email: admin_user.email, password: admin_user.password } }, headers: { 'ACCEPT' => 'application/json' }
      expect(response).to(have_http_status(:ok))
      expect(response.content_type).to(include('application/json'))
    end

    it 'returns a failure response with JSON data' do
      post '/api/v1/users/login', params: { user: { email: admin_user.email, password: 'Password1' } }, headers: { 'ACCEPT' => 'application/json' }
      expect(response).to(have_http_status(:unauthorized))
      expect(response.content_type).to(include('application/json'))
    end
  end
end
