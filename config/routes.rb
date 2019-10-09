Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'sessions/new'
  root 'welcome#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  resources :users do
    member do
      get :following, :followers
    end
    resources :questions do
      resources :answers
    end
  end

  resources :relationships, only: [:create, :destroy]
end
