Rails.application.routes.draw do
  get 'profiles/show'

  root 'home#index'
  scope module: :v1, constraints: ApiConstraint.new(version: 1) do
    devise_for :users, controllers: {
      sessions: 'v1/users/sessions',
      registrations: 'v1/users/registrations',
      omniauth_callbacks: 'v1/users/omniauth_callbacks'
    }

    post '/users/:id/near_by_users' => 'users#near_by_users'
    put '/users/:id/update_location' => 'users#update_location'
    get '/users/terms_of_use' => 'users#terms_of_use'
    get '/users/data_protection' => 'users#data_protection'

    scope :users do
      resources :favorites, only: %i[create destroy index]
    end
    resources :users, only: %i[show edit update destroy]
    resources :profiles
  end
end
