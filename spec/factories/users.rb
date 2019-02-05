require 'faker'
# spec/factories/user
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email('Tricky') }
    key { SecureRandom.hex(5) }
    pwd { SecureRandom.hex(5) }
    password { SecureRandom.hex(10) }
    disabled false
  end

  factory :disabled_user, class: User do
    email { Faker::Internet.email('Motoko') }
    key { SecureRandom.hex(5) }
    pwd { SecureRandom.hex(5) }
    password { SecureRandom.hex(10) }
    disabled true
  end
end
