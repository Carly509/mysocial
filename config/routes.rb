Rails.application.routes.draw do
  devise_for :users

  resources :profiles
  resources :posts do
    resources :comments
    resources :likes, only: [:create, :destroy]
    member do
      post 'repost'
    end
  end

  resources :follows, only: [:create, :destroy]
  resources :messages
  resources :blocks, only: [:create, :destroy]

  root 'posts#index'
end
