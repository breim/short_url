require 'net/http'
# app/models/tracking
class Tracking < ApplicationRecord
  belongs_to :link, optional: true, counter_cache: true

  def self.query_tracking(user)
    joins(:link)
      .where(links: { user_id: user.id }, created_at: 7.days.ago..Time.now)
      .group_by_day('trackings.created_at', format: '%a %d/%m/%y')
      .count
  end

  def self.get_ip_data(ip)
    uri = URI("http://api.ipstack.com/#{ip}?access_key=#{ENV['IPSTACK_ACCESS_KEY']}")
    res = JSON.parse Net::HTTP.get(uri)
    res
  end
end
