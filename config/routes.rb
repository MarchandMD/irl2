Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", :as => :rails_health_check
  resources :users
  resources :tasks
  resources :groups, only: [:index]
  get "/about", to: "about#index"
  root "home#index"
end
