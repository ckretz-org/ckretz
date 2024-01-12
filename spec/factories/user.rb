FactoryBot.define do
  factory :user, class: User do
    id { SecureRandom.uuid }
    email { Faker::Internet.email }
  end
end
