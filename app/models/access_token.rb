class AccessToken < ApplicationRecord
  belongs_to :user, counter_cache: true, optional: false
  validates :name, presence: { strict: true }
  validates :token, presence: { strict: false }

  encrypts :token, deterministic: true

  before_validation do
    self.token = SecureRandom.hex(13)
  end

  after_commit do
    ActiveSupport::Notifications.instrument("created.access_token", { access_token: self })
  end
end
