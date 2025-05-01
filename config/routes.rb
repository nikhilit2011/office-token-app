Rails.application.routes.draw do
  devise_for :users

  resources :tokens, only: [:new, :create]

  authenticated :user do
    root to: "tokens#new", as: :authenticated_root
  end
  
  get "counter_dashboard", to: "tokens#counter_dashboard"
  patch "tokens/:id/update_status", to: "tokens#update_status", as: :update_token_status
  
  get "public_display", to: "tokens#public_display"
  
  get "tokens/:id/print", to: "tokens#print", as: :print_token
  
  get 'tokens/refresh_in_progress', to: 'tokens#refresh_in_progress'
  
  get "tokens/refresh_counter_dashboard", to: "tokens#refresh_counter_dashboard"
  
  
  namespace :admin do
    resources :users, except: [:show]
  end
  
  devise_scope :user do
    get "/logout", to: "devise/sessions#destroy", as: :custom_logout
  end

  devise_scope :user do
    unauthenticated do
      root to: "devise/sessions#new", as: :unauthenticated_root
    end
  end
end
