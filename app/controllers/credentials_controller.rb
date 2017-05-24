class CredentialsController < ApplicationController
  before_action :authenticate_user!
  respond_to :html
  
  def index
  	current_user.update(key: SecureRandom.hex(5), pwd: SecureRandom.hex(5)) if current_user.key.nil?
  end

  def update
  	current_user.update(key: SecureRandom.hex(5), pwd: SecureRandom.hex(5))
  	redirect_to credentials_path
  end
end
