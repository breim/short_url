Rails.application.routes.draw do
  get 'links/index'

  get 'links/show'

	root 'pages#index'

	devise_for :users

	namespace :api do
		resources :links, only: %i(index show create update destroy)
	end
	
end