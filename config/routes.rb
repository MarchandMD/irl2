Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", :as => :rails_health_check
  resources :users
  resources :tasks do
    member do
      post :upvote
      delete :remove_upvote
      post :bookmark
      delete :remove_bookmark
    end
  end
  resources :groups, only: [:index]
  get "/about", to: "about#index"
  root "home#index"
end
