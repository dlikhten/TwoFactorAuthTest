class UserAuthorization < ActiveRecord::Base
  belongs_to :user

  before_save :ensure_token

  def self.create_for_user(user)
    self.new(user: user)
  end

  # tokens is an array of all known remembered tokens
  def self.find_for_user(user, tokens)
    self.where(user_id: user.id, token: tokens).where("expires_at > ?", Time.zone.now)
  end

  def ensure_token
    if token.blank?
      self.token = SecureRandom.uuid
      self.expires_at = 30.days.from_now
    end
  end
end
