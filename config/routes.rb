Rails.application.routes.draw do
	devise_for :users

	namespace :api do
		resources :links, only: %i(index show create update destroy)
	end
	
end