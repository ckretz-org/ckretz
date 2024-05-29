class Secret < ApplicationRecord
  encrypts :name, deterministic: true
  encrypts :value, deterministic: false

  validates :name, presence: { strict: false }
  validates :value, presence: { strict: false }

  after_create_commit { broadcast_prepend_to "secrets" }
  after_update_commit { broadcast_replace_to "secrets" }
  after_destroy_commit { broadcast_remove_to "secrets" }

  belongs_to :user, counter_cache: true, optional: false
end
