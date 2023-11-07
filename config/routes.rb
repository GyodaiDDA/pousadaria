Rails.application.routes.draw do
  root to: 'home#index'
  resources :rooms, only: %I[show new create edit update] do
    resources :seasonals
  end
  resources :inns, only: %I[show new create edit update]
  resources :seasonals

  devise_for :user, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  # get '/inns/new' => 'home#after_registration_path'
end
