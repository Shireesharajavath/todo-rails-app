Rails.application.routes.draw do
  # Root page (browser)
  root "todos#index"

  # Todos CRUD (works for both HTML + JSON if you request with headers)
  resources :todos

  # ---------- API routes (JSON only) ----------
  namespace :api, defaults: { format: :json } do
    post "signup",      to: "users#signup"       # API signup
    post "login",       to: "users#login"        # API login
    post "get_api_key", to: "users#get_api_key"  # Generate/retrieve API key
    get  "me",          to: "users#me"           # Current authenticated user
    get "todos",       to: "todos#index"         # List todos
    
    # New route to fetch all signup users
    get  "users",       to: "users#index"
  end

  # ---------- Todo time logs ----------
  resources :todo_time_logs, only: [] do
    collection do
      post :start
      post :stop
    end
  end
end
