class Secret < ApplicationRecord
  encrypts :value, deterministic: false

  has_neighbors :embedding

  validates :name, presence: { strict: false }
  validates :value, presence: { strict: false }

  after_create_commit do
    broadcast_prepend_to "secrets"
    ActiveSupport::Notifications.instrument("created.secret", { secret: self })
  end
  after_update_commit do
    broadcast_replace_to "secrets"
    ActiveSupport::Notifications.instrument("updated.secret", { secret: self })
  end
  after_destroy_commit { broadcast_remove_to "secrets" }

  include PgSearch::Model
  pg_search_scope :search, against: [ :name ], using: { tsearch: { prefix: true } }

  self.implicit_order_column = "created_at"

  validates :name, uniqueness: { scope: :user_id }
  belongs_to :user, counter_cache: true, optional: false
end
