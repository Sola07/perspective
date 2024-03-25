Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "profile", to: "pages#profile"
  get "info_sci", to: "pages#info_sci"
  get "info_lmnp", to: "pages#info_lmnp"
  patch "update_name/:id", to: "simulations#update_name", as: "update_name"

  resources :simulations do
    member do
      get :edit_first_step
      patch :update_first_step
      get :edit_second_step
      patch :update_second_step
      get :edit_third_step
      patch :update_third_step
      get :edit_last_step
      patch :update_last_step
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
