Rails.application.routes.draw do
  resources :events
  resources :people
  devise_for :doctors
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "dashboard#welcome"
  get '/terms', to: 'dashboard#terms'
  get '/privacy', to: 'dashboard#privacy'
end
