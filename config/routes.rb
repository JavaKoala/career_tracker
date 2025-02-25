Rails.application.routes.draw do
  resources :companies, only: %i[index create show update]
  resources :interview_questions, only: %i[create update destroy]
  resources :interviewers, only: %i[create destroy]
  resources :interviews, only: %i[show create update destroy]
  resources :job_applications, only: %i[index show create update]
  post '/llm_cover_letter', to: 'llm_cover_letter#create'
  resources :next_steps, only: %i[create]
  resources :people, only: %i[create update destroy]
  post '/position_apply', to: 'position_apply#create'
  resources :positions, only: %i[show create update]
  resource :session

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root 'home#index'

  mount RushJob::Engine => '/rush_job', constraints: RushJobConstraint
end
