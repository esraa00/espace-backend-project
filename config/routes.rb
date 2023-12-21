Rails.application.routes.draw do
  # TODO: override the route itself instead of creating new route 
  # method 1:
  # devise_for :users, :controllers => {:registrations => "users/registrations"} do
  #     patch '/users/:id', to: 'users/registrations#update', as: 'user_registration'
  #     put '/users/:id', to: 'users/registrations#update', as: 'user_registration'
  # end

  devise_for :users, defaults: { format: :json }, :controllers => {:registrations => "users/registrations", sessions: 'users/sessions'}
  devise_scope :user do
    put '/users/:id', to: 'users/registrations#update', as: 'custom_update_user_registration'
  end
  resources :users, only: [:show] do
    resources :posts, only: [:create, :destroy, :update]
  end
  resources :posts, only: [:index]
  resources :categories, only:[:index]

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
    mount LetterOpenerWeb::Engine, at: "/letter_opener" 
  end
  post "/graphql", to: "graphql#execute"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
