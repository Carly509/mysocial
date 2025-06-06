Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  #
  root 'flights#index'

  resources :flights, only: [:index, :search] do
    collection do
      get 'search'
      post 'find_flights'
    end
  end
end
