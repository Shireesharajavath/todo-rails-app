Rails.application.routes.draw do
  root "todos#index"

  resources :todos

  get    "signup",     to: "users#new"
  post   "signup",     to: "users#create"

  get    "users",      to: "users#index"
  get    "users/:id",  to: "users#show"
  put    "users/:id",  to: "users#update"
  patch  "users/:id",  to: "users#update"
  delete "users/:id",  to: "users#destroy"

  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  scope defaults: { format: :json } do
    post "get_api_key", to: "users#get_api_key"
  end

  
  resources :todo_time_logs, only: [] do
    collection do
      post :start
      post :stop
    end
  end
end
