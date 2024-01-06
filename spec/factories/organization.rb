FactoryBot.define do
  factory :organization do
    id { SecureRandom.uuid }
    name { Faker::Business.name }
    domain { Faker::Internet.domain_name }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }

    factory :organization_with_owner, parent: :organization do
      transient do
        owner { nil }
      end
      after :create do |organization, evaluator|
        OrganizationUserMembership.create(organization: organization, user: evaluator.owner, role: :owner, invitation_status: :invitation_status_none)
      end
    end
  end
end
