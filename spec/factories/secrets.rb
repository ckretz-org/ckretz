FactoryBot.define do
  factory :secret do
    id { SecureRandom.uuid }
    name { Faker::Alphanumeric.alpha(number: 10).sub(" ", "_") }
    created_at { Time.now }
    user
  end
end
