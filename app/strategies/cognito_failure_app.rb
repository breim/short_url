# Devise failure for Cognito
class CognitoFailureApp < Devise::FailureApp
  def redirect_url
    "#{ENV['COGNITO_AUTH_URL']}/oauth2/authorize?redirect_uri=#{ENV['SERVER_URL']}"
  end

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
