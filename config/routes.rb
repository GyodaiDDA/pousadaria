Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :user, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  get 'cities', to: 'inns#cities'
  resources :inns, only: %I[index show new create edit update] do
    get 'search', on: :collection
  end
  resources :rooms, only: %I[show new create edit update] do
    resources :seasonals, only: %I[index show new create edit]
    get 'availability', to: 'rooms#available?'
  end
end
