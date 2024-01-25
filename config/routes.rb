Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  root "dashboard#index"

  resources :events do
    resource :registrations, only: [:create]
  end
end
