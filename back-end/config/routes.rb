Rails.application.routes.draw do
  resources :metrics, only: :create do
    resources :records, only: :create, module: :metrics
  end

  namespace :reports do
    resources :metrics, only: [:index, :show]
  end
end
