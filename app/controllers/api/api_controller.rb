# app/controllers/api/api_controller
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
    @user =
      User.find_by_key_and_pwd(request.headers['key'], request.headers['pwd'])
    render body: unauthorized_text, status: 401 if unpermited_user?
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
    headers['Access-Control-Allow-Headers'] =
      'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = '1728000'
  end

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = allowed_http_methods
      headers['Access-Control-Allow-Headers'] =
        'X-Requested-With, X-Prototype-Version, Token'
      headers['Access-Control-Max-Age'] = '1728000'
      render text: '', content_type: 'text/plain'
    end
  end

  def allowed_http_methods
    'POST, GET, PUT, DELETE, OPTIONS'
  end
end
