Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#index'
  resources :notes, only: [:index, :create, :update, :destroy]
  resources :tags, only: :index
end
