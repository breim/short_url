class Link < ApplicationRecord
	before_create :build_token
	before_create :build_short_url

	def build_token
		self.token = SecureRandom.hex(3)
	end

	def build_short_url
		self.short_url = "#{ENV['SITE_DOMAIN']}/#{self.token}"
	end
end