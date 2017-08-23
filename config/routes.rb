Rails.application.routes.draw do

  mount Attachinary::Engine => "/attachinary"
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :libraries, only: [ :index, :show, :new, :create, :edit, :update ] do
    resources :reviews, only: [ :new, :create, :edit, :update ]
  end

  resources :books, only: [ :index, :show, :new, :create, :edit, :update ] do
    resources :bookings, only: [ :show, :new, :create ] do
      resources :reviews, only: [ :new, :create, :edit, :update ]
    end
  end

  get '/profile', to: 'pages#profile'
end
