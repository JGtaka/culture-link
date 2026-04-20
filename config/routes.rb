Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
   root "static_pages#top"

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  get "privacy", to: "static_pages#privacy"
  get "terms", to: "static_pages#terms"
  get "profile", to: "profiles#show"
  get "account", to: "accounts#show"
  namespace :account do
    resource :password, only: [ :update ]
  end
  resources :favorites, only: [ :index, :create, :destroy ]
  resources :schedules, only: [ :new, :create, :edit, :update, :destroy ]

  resources :articles, only: [ :index ]
  resources :quizzes, only: [ :index, :show ]
  resources :quiz_results, only: [ :create, :show ]
  resources :characters, only: [ :show ]
  resources :events, only: [ :show ]
  resources :timelines, only: [ :show ]

  namespace :admin do
    root "dashboard#index"
    resources :characters
    resources :events
    resources :masters, only: [ :index ]
    resources :periods, except: [ :show ] do
      collection { patch :reorder }
    end
    resources :regions, except: [ :show ] do
      collection { patch :reorder }
    end
    resources :study_units, except: [ :show ] do
      collection { patch :reorder }
    end
    resources :quiz_categories, except: [ :show ] do
      collection { patch :reorder }
    end
    resources :quizzes do
      member do
        patch :publish
        patch :unpublish
      end
      resources :questions, only: %i[new create edit update destroy]
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
