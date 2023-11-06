Rails.application.routes.draw do
  resources :rooms, only: %I[show new create edit update]

  devise_for :user, controllers: {
    registrations: 'users/registrations'
  }
  root to: 'home#index'
  resources :inns, only: %I[show new create edit update]
  get '/inns/new' => 'home#after_registration_path'
end
