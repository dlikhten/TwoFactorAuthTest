class UserTokenMailer < ActionMailer::Base
  default from: "from@example.com"

  def send_token(token, user = token.user)
    @token = token
    mail(to: user.email, subject: "An attempt was made to log into your account.")
  end
end
