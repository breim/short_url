Rails.application.routes.draw do
	root 'pages#index'
	get '/:token' => 'links#show'
	devise_for :users
	resources :links, only: :index
	resources :credentials, only: %i(index update)

	namespace :api do
		resources :links, only: %i(index show create update destroy)
	end
end