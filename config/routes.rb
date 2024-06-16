Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  mount MissionControl::Jobs::Engine, at: "/jobs"

  resources :secret_values, only: [ :new, :destroy ]
  resources :secrets
  resources :access_tokens, except: [ :update ]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", :as => :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", :as => :pwa_manifest
  get "api/app/info" => "info#index"

  # Defines the root path route ("/")
  root "users#welcome"

  get "/welcome", to: "users#welcome"
  get "/logout", to: "users#logout"

  get "auth/:provider/callback", to: "omniauth#callback"
  post "auth/:provider/callback", to: "omniauth#callback"
  get "auth/failure", to: "omniauth#failure"
end
