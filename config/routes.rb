Rails.application.routes.draw do
  # root 'welcome#index'

  resources :users do
    resources :articles
  end

  resources :articles

  resource :session, only: [:new, :create, :destroy]
  get 'login', to: 'sessions#new'
end
