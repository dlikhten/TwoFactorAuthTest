class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    session = UserSession.new(params[:user_session].permit(:email, :password))
    if session.valid?
      self.current_user = session.user
      redirect_to after_sign_in_path
    else
      @user_session = session
      render 'new'
    end
  end

  def destroy
    log_off
    redirect_to root_path
  end
end
