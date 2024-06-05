class User < ApplicationRecord
  encrypts :email, deterministic: true, downcase: true

  validates :email, format: URI::MailTo::EMAIL_REGEXP, presence: { strict: true }, uniqueness: true
  has_many :secrets, counter_cache: true, dependent: :destroy
  has_many :access_tokens, counter_cache: true, dependent: :destroy

  after_create_commit do
    ActiveSupport::Notifications.instrument("created.user", { user: User.first })
  end

  def chatbot_jwt_token
    JWT.encode({ user_id: id }, ENV.fetch("SHARED_JWT_SECRET", "ckretz_secret"), "HS256")
  end
  self.implicit_order_column = "created_at"
end
