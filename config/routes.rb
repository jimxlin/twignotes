Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#index'
  resources :notes
  resources :tags, only: :index
  resources :taggings, only: :index
end
