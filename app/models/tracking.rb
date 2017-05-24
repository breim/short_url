require 'net/http'
class Tracking < ApplicationRecord
  belongs_to :link, optional: true

  def self.get_ip_data(ip)
  	uri = URI("http://freegeoip.net/json/#{ip}")
	res = JSON.parse Net::HTTP.get(uri)
  	res
  end
  
end