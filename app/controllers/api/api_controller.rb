# app/controllers/api/api_controller
module Api
  # class
  class ApiController < ApplicationController
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
      if request.headers['HTTP_EXTERNAL_ID'].present?
        @user = get_user_from_cognito(request.headers['HTTP_EXTERNAL_ID'], request.headers['key'], request.headers['pwd'])
        if @user.nil?
          resp = HTTParty.get(ENV['TOKEN_SERVICE_LOCATION'] + '/verify/' + @user.cognito_id, body: { urli_me_key: @user.key,
                                                                                                     urli_me_pwd: @user.pwd })
        end
      else
        @user = User.find_by_key_and_pwd(request.headers['key'], request.headers['pwd'])
      end
      render body: unauthorized_text, status: 401 if unpermited_user? || (resp.present? && resp.body == 'invalid_token')
    end

    def cognito_client
      Aws::CognitoIdentityProvider::Client.new(
        region: ENV['AWS_REGION'],
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      )
    end

    def get_user_attributes_from_cognito(resp)
      cognito_attributes = JSON.parse resp.user_attributes.to_json
      user_attributes = { disabled: false }
      cognito_attributes.each do |user_attr|
        user_attributes[:cognito_id] = user_attr['value'] if user_attr['name'] == 'sub'
        user_attributes[:email] = user_attr['value'] if user_attr['name'] == 'email'
        user_attributes[:company] = user_attr['value'] if user_attr['name'] == 'custom:company'
      end
      user_attributes
    end

    def get_user_from_cognito(external_id, key, pwd)
      user = User.find_by_cognito_id(external_id)

      # Try to fetch user not locally created from cognito
      resp = cognito_client.admin_get_user(
        user_pool_id: ENV['COGNITO_USER_POOL_ID'], # required
        username: external_id
      )
      user_attributes = get_user_attributes_from_cognito(resp)
      user_attributes[:key] = key
      user_attributes[:pwd] = pwd
      return User.create!(user_attributes) if user.nil?

      user.update!(user_attributes)
      user
    rescue Aws::CognitoIdentityProvider::Errors::UserNotFoundException
      nil
    end

    def unauthorized_text
      'Unauthorized - Check your credentials'
    end

    def unpermited_user?
      @user.nil? || @user.disabled?
    end

    def object_not_found
      render body: 'Object not found', status: 403
    end

    def cors_set_access_control_headers
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = allowed_http_methods
      headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
      headers['Access-Control-Max-Age'] = '1728000'
    end

    def cors_preflight_check
      return unless request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = allowed_http_methods
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token'
      headers['Access-Control-Max-Age'] = '1728000'
      render text: '', content_type: 'text/plain'
    end

    def allowed_http_methods
      'POST, GET, PUT, DELETE, OPTIONS'
    end
  end
end
