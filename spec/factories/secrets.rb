FactoryBot.define do
  factory :secret do
    id { SecureRandom.uuid }
    name { Faker::Alphanumeric.alpha(number: 10) }
    value { Faker::Crypto.md5 }
    created_at { Time.now }
    user
  end
end
