Rails.application.routes.draw do
  resources :metrics, only: :create do
    resources :records, only: :create, module: :metrics
  end

  # Defines the root path route ("/")
  # root "articles#index"
end
