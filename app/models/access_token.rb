class AccessToken < ApplicationRecord
  belongs_to :user, optional: false
  validates :name, presence: { strict: true }
  validates :token, presence: { strict: true }
end
