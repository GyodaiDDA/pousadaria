Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :user, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  devise_scope :user do
    get 'users/edit_document', to: 'users/registrations#edit_document', as: :edit_customer_document
    patch 'users/update_document', to: 'users/registrations#update_document', as: :update_customer_document
  end

  resources :inns, only: %i[index show new create edit update] do
    get 'search', on: :collection
    get 'cities', on: :collection
    get 'reservations', to: 'reservations'
    get 'ratings', to: 'ratings'
  end

  resources :rooms, only: %i[show new create edit update] do
    resources :seasonals, only: %i[index show new create edit]
    resources :reservations, only: %i[index show new create edit update]
  end
  get 'reservations/retrieve', to: 'reservations#retrieve'
  patch 'rooms/:room.id/reservations/:id', to: 'reservations#reclaim'
  get 'reservations/list', to: 'reservations#list'
end
