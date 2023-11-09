Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :user, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  get 'inns/cities', to: 'inns#cities'
  resources :inns, only: %I[index show new create edit update]
  resources :rooms, only: %I[show new create edit update] do
    resources :seasonals
  end
end
