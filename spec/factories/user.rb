FactoryBot.define do
  factory :user, class: User do
    email { Faker::Internet.email }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
end
