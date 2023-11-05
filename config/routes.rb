Rails.application.routes.draw do
  devise_for :user, controllers: {
    registrations: 'user/registrations'
  }
  root to: 'home#index'
  resources :inns, only: %I[show new create edit update]
end
