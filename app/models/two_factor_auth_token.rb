class TwoFactorAuthToken < ActiveRecord::Base
  belongs_to :user

  before_save :ensure_token
  after_create :send_token_to_user

  def self.create_for_user(user)
    self.new(user: user)
  end

  def self.find_for_user(user, token)
    self.where(user_id: user.id, token: token).where("expires_at > ?", Time.zone.now).first
  end

  def ensure_token
    if token.blank?
      self.token = SecureRandom.random_number(899999) + 100000
      self.expires_at = 1.hour.from_now
    end
  end

  def send_token_to_user
    UserTokenMailer.send_token(self).deliver
  end
end
