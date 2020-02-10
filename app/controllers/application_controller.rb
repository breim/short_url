require 'application_responder'

# app/controllers/application_controller
class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  helper_method :current_user

  private

  def authenticate_user!
    warden.authenticate!
  end

  def after_sign_in_path_for(_resource)
    if current_user.present?
      links_path
    else
      "#{ENV['COGNITO_AUTH_URL']}/oauth2/authorize?redirect_uri=#{ENV['SERVER_URL']}"
    end
  end
end
