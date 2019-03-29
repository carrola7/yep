Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'ui(/:action)', controller: 'ui'
  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
  get 'register', to: 'users#new', as: :register
  get 'home', to: 'pages#front', as: :home 
  root to: 'pages#front'

  resources :users, only: [:create]
  resources :sessions, only: [:create]
  resources :businesses, only: [:index, :show, :create, :edit, :new, :update] do
    resources :reviews, only: [:show, :create, :edit, :new, :update]
  end
  resources :reviews, only: [:index]
end
