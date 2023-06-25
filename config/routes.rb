# frozen_string_literal: true

Rails.application.routes.draw do
  Rails.application.routes.draw do
    devise_for :users, path: 'users',
                       path_names: {
                         sign_in: 'login',
                         sign_out: 'logout'
                       }
  end
  # Defines the root path route ("/")
  root 'main#index'
end
