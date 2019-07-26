# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  root to: "foods#index"
  get "/shopping_list", to: "shopping_items#index"
  get "/disclaimer", to: "home#disclaimer"

  resources :foods, except: :show
  resources :food_categories, except: :show
  resources :users, except: :index
  resources :user_groups, only: [:show]
  resources :invitations, only: [:create, :edit, :update, :show]

  namespace "api" do
    resources :foods, only: [:index, :update]
    resources :food_categories, only: :index do
      resource :position, only: [:update], controller: "food_categories/position"
    end
    resources :shopping_items, only: [:index]
  end
end
