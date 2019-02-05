require 'faker'

FactoryBot.define do
  factory :tracking do
    referer { Faker::Internet.url }
    browser { Faker::Internet.user_agent }
    ip { Faker::Internet.public_ip_v4_address }
    link
  end
end