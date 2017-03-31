Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#index'
  get 'about', to: 'static_pages#about'
  resources :notes, except: :new
  resources :tags, only: :index
end
