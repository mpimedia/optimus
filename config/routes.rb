Rails.application.routes.draw do
  devise_for :users

  root to: "static#home"

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  namespace :admin do
    root to: "dashboard#index"

    # authenticate :user, lambda { |u| u.admin? } do
    #   mount Blazer::Engine, at: :blazer
    #   mount GoodJob::Engine, at: :good_job
    #   mount MaintenanceTasks::Engine, at: :maintenance_tasks
    #   mount PgHero::Engine, at: :pghero
    # end

    # if Rails.env.development? || Rails.env.staging?
    #   authenticate :user, lambda { |u| u.admin? } do
    #     mount RailsDb::Engine, at: "/rails/db", as: :rails_db
    #   end
    # end

    # if Rails.env.development?
    #   authenticate :user, lambda { |u| u.admin? } do
    #     mount Lookbook::Engine, at: :lookbook
    #   end
    # end
  end

  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      # resources :authentication_tokens, only: [:create]
      # resources :users, only: [:index, :create]
    end
  end
end
