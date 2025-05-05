Rails.application.routes.draw do
  # Devise authentication
  devise_for :users

  # Token creation routes
  resources :tokens, only: [:new, :create]

  # Root paths
  authenticated :user do
    root to: "tokens#new", as: :authenticated_root
  end

  devise_scope :user do
    unauthenticated do
      root to: "devise/sessions#new", as: :unauthenticated_root
    end

    get "/logout", to: "devise/sessions#destroy", as: :custom_logout
  end

  # Counter Incharge Dashboards
  get "all_tokens", to: "tokens#all_tokens"
  get "live_tokens", to: "tokens#live_tokens"
  get "tokens/refresh_live_tokens", to: "tokens#refresh_live_tokens"
  get "tokens/refresh_counter_dashboard", to: "tokens#refresh_counter_dashboard" # If used elsewhere

  # Status update
  patch "tokens/:id/update_status", to: "tokens#update_status", as: :update_token_status

  # Public token display
  get "public_display", to: "tokens#public_display"
  get "tokens/refresh_in_progress", to: "tokens#refresh_in_progress"

  # Token printing
  get "tokens/:id/print", to: "tokens#print", as: :print_token

  # Admin namespace
  namespace :admin do
    resources :users, except: [:show]
  end
end
