class AccessToken < ApplicationRecord
  belongs_to :user, optional: false
  validates :name, presence: { strict: true }
  validates :token, presence: { strict: false }

  before_validation do
    self.token = SecureRandom.hex(13)
  end

  after_commit do
    ActiveSupport::Notifications.instrument("created.access_token", { access_token: self })
  end
end
