Rails.application.routes.draw do
  root to: "charges#new"
  resources :charges, only: [:new, :create]
end
