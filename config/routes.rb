Rails.application.routes.draw do
  scope module: :v1, constraints: ApiConstraint.new(version: 1) do
    devise_for :users, controllers: {
        sessions: 'v1/users/sessions',
        registrations: 'v1/users/registrations'
      }
  end
end
