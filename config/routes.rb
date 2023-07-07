# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :users do
        devise_for :users, path: '',
                           path_names: {
                             sign_in: 'login',
                             sign_out: 'logout'
                           },
                           controllers: {
                             confirmations: 'api/v1/users/confirmations',
                             passwords: 'api/v1/users/passwords',
                             registrations: 'api/v1/users/registrations',
                             sessions: 'api/v1/users/sessions',
                             unlocks: 'api/v1/users/unlocks'

                           }
      end
    end
  end
  # Defines the root path route ("/")
  root 'main#index'
end
