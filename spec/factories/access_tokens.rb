FactoryBot.define do
  factory :access_token do
    id { SecureRandom.uuid }
    name { Faker::Alphanumeric.alpha(number: 10) }
    token { Faker::Crypto.md5 }
    user
  end
end
