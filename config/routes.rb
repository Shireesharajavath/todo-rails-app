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
    post "logout",      to: "users#logout"       # ✅ API logout endpoint

    # ✅ RESTful todos (for API)
    resources :todos, only: [:index]

    # ✅ RESTful users (adds POST /api/users, GET /api/users/:id, etc.)
    resources :users, only: [:create, :index, :show]
  end

  # ---------- Todo time logs ----------
  resources :todo_time_logs, only: [] do
    collection do
      post :start
      post :stop
    end
  end
end
