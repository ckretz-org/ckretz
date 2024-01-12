class User < ApplicationRecord
  encrypts :email, deterministic: true, downcase: true

  validates :email, format: URI::MailTo::EMAIL_REGEXP
  has_many :secrets, counter_cache: true, dependent: :destroy
  has_many :access_tokens, counter_cache: true, dependent: :destroy

  after_commit do
    ActiveSupport::Notifications.instrument("created.user", { user: self })
  end
end
