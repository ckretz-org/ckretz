class Secret < ApplicationRecord
  encrypts :value, deterministic: false

  validates :name, presence: { strict: false }
  validates :value, presence: { strict: false }

  after_create_commit { broadcast_prepend_to "secrets" }
  after_update_commit { broadcast_replace_to "secrets" }
  after_destroy_commit { broadcast_remove_to "secrets" }

  include PgSearch::Model
  pg_search_scope :search, against: [:name], using: { tsearch: { prefix: true } }

  self.implicit_order_column = "created_at"

  validates :name, uniqueness: { scope: :user_id }
  belongs_to :user, counter_cache: true, optional: false
end
