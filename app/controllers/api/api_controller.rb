class Api::ApiController < ApplicationController
	protect_from_forgery

	# OAuth Code
	before_action :set_user

	# Object not found
	rescue_from ActiveRecord::RecordNotFound, with: :object_not_found

	# Disable Cors
	before_action :cors_preflight_check
	after_action :cors_set_access_control_headers
	skip_before_action :verify_authenticity_token

private
	def set_user
		@user = User.find_by_key_and_pwd(request.headers["key"], request.headers["pwd"])
		render body: 'Unauthorized - Check your credentials', status: 401 if @user.nil? or @user.disabled?
	end

	def object_not_found
		render body: 'Object not found', status: 403
	end
	
	def cors_set_access_control_headers
		headers['Access-Control-Allow-Origin'] = '*'
		headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
		headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
		headers['Access-Control-Max-Age'] = "1728000"
	end

	def cors_preflight_check
		if request.method == 'OPTIONS'
			headers['Access-Control-Allow-Origin'] = '*'
			headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
			headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token'
			headers['Access-Control-Max-Age'] = '1728000'
			render :text => '', :content_type => 'text/plain'
		end
	end
end