Rails.application.routes.draw do
	root 'pages#index'
	devise_for :users
	resources :links, only: :index
	resources :credentials, only: %i(index update)
	get '/:token' => 'links#show'

	namespace :api do
		resources :links, only: %i(index show create update destroy)
	end
end