# Cognito Authentication Strategy
# It'll find if there is a cookie set with user credentials, like:
# 1 - Cognito Access Token
# 2 - Cognito User Email
# 3 - Cognito User Unique Identifier (uuid) or sub field.
# The real authentication occurs in Chiligum Creatives Authentication App and then
# this app sicronizes with the Authentication App to get user's credentials
class CognitoTokenStrategy < Warden::Strategies::Base
  def valid?
    access_token.present? && user_email.present? && uuid.present?
  end

  def authenticate_user!
    authenticate!
  end

  def authenticate!
    if valid_access_token?
      user = User.find_by(email: user_email)
      if user.nil?
        user = User.create(user_attributes)
      else
        user.update(user_attributes)
      end
      success!(user)
    else
      fail!('Invalid session, please sign in again')
    end
  end

  private

  # JWT Vality - Step 1
  # A JSON Web Token (JWT) includes three sections:
  # 1 - Header, 2 - Payload, 3 - Signature.
  # Between each section it must has a dot "." and the JWT is encoded as Base64 url strings.
  # So we must verify if JWT has 2 dots and is a valid Base64 url string.
  def base64?
    token_without_section = access_token.delete('.')
    access_token.count('.').eql?(2) && token_without_section.match(%r/[A-Za-z0-9+\/]+={0,3}/).string == token_without_section
  end

  # JWT Vality - Step 2
  # It validates the signature presented in JWT token.
  # If the token is invalid it'll raise an JWT::VerificationError
  def valid_signature?(rsa_public)
    JWT.decode(access_token, rsa_public, true, algorithm: 'RS256')
  end

  # JWT Vality - Step 3
  # It validates the claims inside the token decodified.
  # - The Token must not be expired
  # - The Token client_id  should match the app client ID on cognito
  # - The Token iss should match our user pool.
  # - The Token use must be 'access'
  def valid_claims?(decoded_token)
    return false if Time.now > Time.at(decoded_token[0]['exp'])
    return false unless decoded_token[0]['aud'].eql?(ENV['COGNITO_CLIENT_ID']) || decoded_token[0]['client_id'].eql?(ENV['COGNITO_CLIENT_ID'])
    return false unless decoded_token[0]['iss'].eql?("https://cognito-idp.us-east-1.amazonaws.com/#{ENV['COGNITO_USER_POOL_ID']}")
    return false unless decoded_token[0]['token_use'].eql?('access') || decoded_token[0]['token_use'].eql?('id')

    true
  end

  def load_jwks
    JSON.parse(File.read('jwks.json'))['keys']
  end

  # Cognito Access Token is an JSON Web Token (JWT)
  # So we need to verify if it's a valid JWT.
  # The steps to validate this token it uses the following AWS approach:
  # https://docs.aws.amazon.com/cognito/latest/developerguide/amazon-cognito-user-pools-using-tokens-verifying-a-jwt.html
  def valid_access_token?
    return false unless base64?

    jwks = load_jwks
    jwk = JSON::JWK.new(jwks[1])
    rsa_public = jwk.to_key
    decoded_token = valid_signature?(rsa_public)
    return false unless valid_claims?(decoded_token)

    true
  rescue JWT::VerificationError, JWT::ExpiredSignature
    false
  end

  def access_token
    cookies['user_token']
  end

  def user_email
    cookies['user_email']
  end

  def uuid
    cookies['uuid']
  end

  def client
    Aws::CognitoIdentityProvider::Client.new(
      region: ENV['AWS_REGION'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )
  end

  def user_attributes
    attributes = {
      email: user_email,
      cognito_id: '',
      company: ''
    }

    resp = client.admin_get_user(
      user_pool_id: ENV['COGNITO_USER_POOL_ID'],
      username: user_email
    )

    cognito_attributes = JSON.parse resp.user_attributes.to_json
    cognito_attributes.each do |user_attr|
      attributes[:cognito_id] = user_attr['value'] if user_attr['name'] == 'sub'
      attributes[:company] = user_attr['value'] if user_attr['name'] == 'custom:company'
    end

    attributes
  end
end
