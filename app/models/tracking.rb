require 'net/http'
# app/models/tracking
class Tracking < ApplicationRecord
  belongs_to :link, optional: true, counter_cache: true

  def self.get_ip_data(ip)
    uri = URI("http://freegeoip.net/json/#{ip}")
    res = JSON.parse Net::HTTP.get(uri)
    res
  end
end
