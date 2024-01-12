class Secret < ApplicationRecord
  encrypts :name, deterministic: true
  encrypts :value, deterministic: false

  validates :name, presence: { strict: true }
  validates :value, presence: { strict: true }

  belongs_to :user, counter_cache: true, optional: false
end
