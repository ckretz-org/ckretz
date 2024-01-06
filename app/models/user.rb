class User < ApplicationRecord
  encrypts :email, deterministic: true, downcase: true

  validates :email, format: URI::MailTo::EMAIL_REGEXP

  after_commit do
    ActiveSupport::Notifications.instrument("created.user", { user: self })
  end
end
