Rails.application.routes.draw do
  resources :user_books
  resources :users
  root "user_books#index"
  resources :books do
    get :delete, on: :member
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
