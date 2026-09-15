Rails.application.routes.draw do
  root "books#index"
  resources :books do
    get :delete, on: :member
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
