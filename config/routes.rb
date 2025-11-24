Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "users/registrations"}
  devise_scope :user do
    delete "users/registration/remove_profile_photo", to: "users/registrations#remove_profile_photo", as: :remove_profile_photo_user_registration
  end
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
