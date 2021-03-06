Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'ui(/:action)', controller: 'ui'
  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
  get 'register', to: 'users#new', as: :register
  get 'home', to: 'pages#front', as: :home
  root to: 'pages#front'

  resources :users, param: :slug, except: %i[index new destroy]
  resources :settings, param: :slug, only: %i[edit update]
  resources :sessions, only: :create
  resources :businesses, param: :slug, except: :destroy do
    resources :reviews, param: :slug, except: %i[index destroy]
    get 'search', on: :collection
  end
  resources :reviews, only: :index
  resources :tags, param: :slug, only: :show
end
