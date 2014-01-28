class UserSession
  extend ActiveModel::Naming
  extend ActiveModel::Conversion

  attr_accessor :email
  attr_accessor :password

  def persisted?
    false
  end

  def to_key
    nil
  end

  def initialize(params = {})
    @email = params[:email]
    @password = params[:password]
  end

  def user
    @user ||= User.find_by_email(@email).try(:authenticate, @password)
  end

  def valid?
    user.present?
  end
end
