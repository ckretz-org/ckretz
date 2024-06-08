class SecretValue < ApplicationRecord
  validates :name, presence: { strict: false }
  validates :value, presence: { strict: false }
  self.implicit_order_column = "created_at"
  belongs_to :secret, counter_cache: true, optional: false
  validates :name, uniqueness: { scope: :secret_id }
  encrypts :name, deterministic: true
  encrypts :value, deterministic: false

end
