Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "api/v1/auth", controllers: {
    registrations: "api/v1/auth/registrations",
    sessions: "api/v1/auth/sessions",
    passwords: "api/v1/auth/passwords"
  }

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :brands, :products do
        member do
          patch :update_state
        end
      end
      resources :clients, only: %i[ create destroy ]
      resources :access_sessions, only: %i[ create destroy ]
      resources :cards, only: %i[ create ] do
        member do
          patch :active
          patch :cancel
        end
      end
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
