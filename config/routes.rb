Rails.application.routes.draw do
  devise_for :users

  # Token generation (for operator)
  resources :tokens, only: [:new, :create] do
    member do
      get :print
      patch :update_status
    end

    collection do
      get :all_tokens
      get :live_tokens
      get :refresh_live_tokens
      get :public_display
      get :refresh_in_progress
    end
  end

  # Legacy and renamed routes for clarity
  get "counter_dashboard", to: redirect("tokens/all_tokens") # old name redirect

  # Admin routes
  namespace :admin do
    resources :users, except: [:show]
  end

  # Authenticated user root (e.g., token operator lands on generate token)
  authenticated :user do
    root to: "tokens#new", as: :authenticated_root
  end

  # Devise logout
  devise_scope :user do
    get "/logout", to: "devise/sessions#destroy", as: :custom_logout
  end

  # Default unauthenticated root
  devise_scope :user do
    unauthenticated do
      root to: "devise/sessions#new", as: :unauthenticated_root
    end
  end
end
