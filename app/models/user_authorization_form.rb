class UserAuthorizationForm
  extend ActiveModel::Naming
  extend ActiveModel::Conversion

  attr_reader :token, :remember_authorization, :user

  def persisted?
    false
  end

  def to_key
    nil
  end

  def initialize(user, params = {})
    @user = user
    @token = params[:token]
    @remember_authorization = ActiveRecord::ConnectionAdapters::Column.value_to_boolean(params[:remember_authorization])
  end

  def tfa_token
    @tfa_token ||= TwoFactorAuthToken.find_for_user(user, token)
  end

  def valid?
    tfa_token.present?
  end

  def authorize!
    UserAuthorization.transaction do
      tfa_token.destroy
      @auth_token ||= UserAuthorization.create_for_user(user)
      @auth_token.save!

      @auth_token
    end
  end

  def remember_authorization?
    remember_authorization.present?
  end
end
