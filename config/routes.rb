Rails.application.routes.draw do
  get "tasks/index"
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check
  resources :users
  resources :tasks
  root "home#index"
end
