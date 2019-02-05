# app/helpers/link_helper.rb
module LinksHelper
  def header_auth(key, pwd)
    request.headers['key'] = key
    request.headers['pwd'] = pwd
  end
end
