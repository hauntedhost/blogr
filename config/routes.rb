Rails.application.routes.draw do
  # root 'welcome#index'

  resources :users do
    resources :articles, only: [:index]
  end

  resources :articles

  resource :session, only: [:new, :create, :destroy]
  get 'login', to: 'sessions#new'
end
