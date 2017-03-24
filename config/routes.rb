Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#index'
  get 'notes/filtered', to: 'notes#filtered_index'
  resources :notes, only: [:create, :update, :destroy]
  resources :tags, only: :index
end
