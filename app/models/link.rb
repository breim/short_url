# app/models/link
class Link < ApplicationRecord
  has_many :trackings, dependent: :destroy
  belongs_to :user

  before_create :build_token, :build_short_url

  validates :original_url, format: URI.regexp(%w(http https)), presence: true

  def build_token
    self.token = SecureRandom.hex(3)
  end

  def build_short_url
    self.short_url = "#{ENV['SITE_DOMAIN']}/#{token}"
  end
end
