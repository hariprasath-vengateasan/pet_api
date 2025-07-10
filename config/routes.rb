require "sidekiq/web"
require "letter_opener_web"

Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore,
  key: "_pet_api_sidekiq_session",
  same_site: :strict,
  secret: Rails.application.secret_key_base

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  mount Sidekiq::Web => "/sidekiq"
  mount LetterOpenerWeb::Engine, at: "/inbox" if Rails.env.development?

  resources :pets, only: [:index, :show, :create, :update] do
    member { patch :expire_vaccination }
  end
end
