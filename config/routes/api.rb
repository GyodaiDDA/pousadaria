namespace :api do
  namespace :v1 do
    resources :inns, only: %i[index show] do
      resources :rooms, only: %i[index]
    end
    post 'rooms/:room_id/reservation', to: 'reservations#create', as: :room_reservation
  end
end
