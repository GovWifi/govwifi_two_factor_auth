Dummy::Application.routes.draw do
  root to: "home#index"

  match "/dashboard", to: "home#dashboard", as: :dashboard, via: [:get]

  devise_for :users
end
