Rails.application.routes.draw do
  root to: "plans#index"

  resources :plans, only: :index do
    resources :registrations, only: [:new, :create, :show]
  end
end
