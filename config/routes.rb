Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    get "tokens", to: "tokens#index"
    get "tokens/by_symbol/:symbol", to: "tokens#by_symbol"
    get "tokens/:id", to: "tokens#show"
  end
end
