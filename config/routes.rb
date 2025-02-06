Rails.application.routes.draw do
  resources :interview, only: %i[show create update destroy]
  resources :interview_question, only: %i[create update destroy]
  resources :interviewer, only: %i[create destroy]
  resource :session
  resources :job_application, only: %i[index show create update]
  resources :company, only: %i[index create show update]
  resources :position, only: %i[show create update]
  resources :person, only: %i[create update destroy]

  post '/position_apply', to: 'position_apply#create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root 'home#index'
end
