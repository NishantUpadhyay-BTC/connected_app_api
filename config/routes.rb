Rails.application.routes.draw do
  get 'profiles/show'

  scope module: :v1, constraints: ApiConstraint.new(version: 1) do
    devise_for :users, controllers: {
        sessions: 'v1/users/sessions',
        registrations: 'v1/users/registrations'
      }

    get '/users/:id/near_by_users' => 'users#near_by_users'
    put '/users/:id/update_location' => 'users#update_location'

    resources :users, only: :show
    resources :profiles
  end
end
