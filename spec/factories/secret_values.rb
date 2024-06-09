# frozen_string_literal: true

FactoryBot.define do
  factory :secret_value do
    id { SecureRandom.uuid }
    name { Faker::Alphanumeric.alpha(number: 10) }
    value { Faker::Crypto.md5 }
    created_at { Time.now }
    secret
  end
end
