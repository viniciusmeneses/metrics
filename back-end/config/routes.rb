Rails.application.routes.draw do
  resources :metrics, only: :create

  # Defines the root path route ("/")
  # root "articles#index"
end
