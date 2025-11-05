Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :posts, param: :handle, only: %i[index show]

  namespace :admin do
    resources :posts, param: :handle
    resources :sessions, only: %i[create new] do
      collection do
        post :logout, to: "sessions#destroy"
      end
    end
  end

  root "posts#index"
  get  :feed, to: "posts#index", defaults: { format: :xml }

  match "*path" => "posts#index", via: %i[get post put patch delete]
end
