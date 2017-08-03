Rails.application.routes.draw do
  scope module: :v1, constraints: ApiConstraint.new(version: 1) do
    devise_for :users, controllers: {
        sessions: 'v1/users/sessions',
        registrations: 'v1/users/registrations'
      }
    resources :articles, only: :index
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
