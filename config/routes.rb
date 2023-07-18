# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  devise_for :users, path: 'api/v1/users',
                     path_names: {
                       sign_in: 'login',
                       sign_out: 'logout'
                     },
                     controllers: {
                       sessions: 'api/v1/users/sessions',
                       registrations: 'api/v1/users/registrations',
                       passwords: 'api/v1/users/passwords',
                       confirmations: 'api/v1/users/confirmations',
                       unlocks: 'api/v1/users/unlocks'
                     }

  # Defines the root path route ("/")
  # home route is defined in app/controllers/api/v1/movies_controller.rb
  root to: 'api/v1/movies#index'

  namespace :api do
    namespace :v1 do
      resources :movies do
        resources :reviews
      end
    end
  end
end
