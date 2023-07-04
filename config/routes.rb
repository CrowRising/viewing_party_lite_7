# frozen_string_literal: true

Rails.application.routes.draw do
  resources :user_viewing_parties
  resources :viewing_parties
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
