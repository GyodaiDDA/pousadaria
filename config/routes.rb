Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :user, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  devise_scope :user do
    get 'users/document_edit', to: 'users/registrations#document_edit', as: :edit_customer_document
    patch 'users/document_update', to: 'users/registrations#document_update', as: :update_customer_document
  end

  get 'cities', to: 'inns#cities'
  resources :inns, only: %i[index show new create edit update] do
    get 'search', on: :collection
  end

  resources :rooms, only: %i[show new create edit update] do
    resources :seasonals, only: %i[index show new create edit]
    resources :reservations, only: %i[show new create edit update]
  end
end
