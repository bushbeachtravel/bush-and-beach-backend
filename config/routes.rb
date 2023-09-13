Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  
  controllers: {
    sessions: 'api/v1/users/sessions',
    registrations: 'api/v1/users/registrations'
  }

  namespace :api do
    namespace :v1 do
      resources :users do
        resources :posts, only: %i[create update destroy] do
          resources :likes, :comments
        end
        resources :photos, only: %i[create update destroy]
      end
      resources :posts, only: %i[show index] do
        resources :likes, :comments
      end
      resources :photos, only: %i[show index]
    end
  end
  get '/current_user', to: 'current_user#index'
end