FactoryBot.define do
  factory :access_token do
    name { Faker::Alphanumeric.alpha(number: 10) }
    token { Faker::Crypto.md5 }
  end
end
