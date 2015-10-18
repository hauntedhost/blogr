Rails.application.routes.draw do
  # root 'welcome#index'
  resources :articles
  resource :session, only: [:new, :create, :destroy]
  get 'login', to: 'sessions#new'
end
