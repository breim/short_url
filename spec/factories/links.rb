require 'faker'

FactoryBot.define do
  factory :link do
    original_url { Faker::Internet.url }
    user
  end
end
