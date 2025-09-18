# config/routes.rb
Rails.application.routes.draw do
  # Root path -> Todos index
  root "todos#index"

  # Todos CRUD (standard RESTful routes)
  resources :todos

  # Users
  get    "signup",     to: "users#new"      # signup form
  post   "signup",     to: "users#create"   # signup submit
  get    "users",      to: "users#index"    # list users
  get    "users/:id",  to: "users#show"     # show user
  put    "users/:id",  to: "users#update"   # update user (full)
  patch  "users/:id",  to: "users#update"   # update user (partial)
  delete "users/:id",  to: "users#destroy"  # delete user

  # API key retrieval (bypasses auth, JSON-only)
  post "get_api_key", to: "users#get_api_key", defaults: { format: :json }

  # Sessions (login/logout)
  get    "login",  to: "sessions#new"      # login form
  post   "login",  to: "sessions#create"   # login submit
  delete "logout", to: "sessions#destroy"  # logout
end
