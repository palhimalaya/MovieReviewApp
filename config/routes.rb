Rails.application.routes.draw do
  Rails.application.routes.draw do
      devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
      }
  end
  # Defines the root path route ("/")
  root "main#index"
end
