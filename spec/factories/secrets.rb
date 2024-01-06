FactoryBot.define do
  factory :secret do
    name { Faker::Alphanumeric.alpha(number: 10) }
    value { Faker::Crypto.md5 }
  end
end
