class User < ApplicationRecord
  encrypts :email, deterministic: true, downcase: true

  validates :email, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  after_commit do
    ActiveSupport::Notifications.instrument("created.user", { user: self })
  end
end
