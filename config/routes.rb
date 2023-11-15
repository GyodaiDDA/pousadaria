Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :user, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  get 'cities', to: 'inns#cities'
  resources :inns, only: %i[index show new create edit update] do
    get 'adv_search', on: :collection
    get 'search', on: :collection
  end
  resources :rooms, only: %i[show new create edit update] do
    resources :seasonals, only: %i[index show new create edit]
    resources :reservations, only: %i[show new create]
  end
end
