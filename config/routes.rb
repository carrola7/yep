Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'ui(/:action)', controller: 'ui'
  get 'login', to: 'sessions#new', as: :login
  get 'register', to: 'users#new', as: :register
  get 'home', to: 'pages#front', as: :home 

  resources :users, only: [:create]
  resources :sessions, only: [:create]
end
