Rails.application.routes.draw do
  namespace :admin do
    root to: "dashboard#index"
    resources :tasks do
      collection do
        post :archive_all
        post :bulk_archive
      end
      member do
        post :unarchive
      end
    end
    resources :users do
      collection do
        post :bulk_archive
      end
      member do
        post :unarchive
      end
    end
    resources :comments, only: [:index, :destroy]
    resources :submissions, only: [:index, :show, :destroy]
  end

  devise_for :users, controllers: {registrations: "users/registrations", omniauth_callbacks: "users/omniauth_callbacks"}
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
    resources :submissions, only: [:create, :edit, :update] do
      member do
        post :upvote
        delete :remove_upvote
      end
    end
    resources :comments, only: [:create, :destroy]
  end
  resources :submissions, only: [:index] do
    resources :comments, only: [:create, :destroy]
  end
  resources :groups, only: [:index]
  get "/about", to: "about#index"
  resources :channels, only: %i[index show] do
    resources :messages, only: %i[create]
  end
  root "home#index"
end
