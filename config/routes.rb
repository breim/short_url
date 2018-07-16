# config/routes
Rails.application.routes.draw do
  root 'pages#index'
  devise_for :users
  resources :links, only: :index
  resources :credentials, only: %i(index update)
  resources :reports, only: :create
  get '/:token' => 'links#show'

  namespace :api do
    resources :links, only: %i(index show create update destroy)
    resources :trackings, only: :show
  end
end
