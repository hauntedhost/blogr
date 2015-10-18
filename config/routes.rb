Rails.application.routes.draw do
  root 'articles#index'

  resources :users do
    resources :articles, only: [:index]
  end

  resources :articles

  resource :session, only: [:new, :create, :destroy]
  get 'login', to: 'sessions#new'
  get 'logout', to: 'sessions#destroy'
end
