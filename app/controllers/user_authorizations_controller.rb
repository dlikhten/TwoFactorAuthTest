class UserAuthorizationsController < ApplicationController
  before_action :ensure_logged_in
  before_action :ensure_not_authorized

  def new
    TwoFactorAuthToken.create_for_user(current_user).save!
    @user_authentication_form = UserAuthorizationForm.new(current_user)
  end

  def create
    UserAuthorization.transaction do
      auth = UserAuthorizationForm.new(current_user, params[:user_authorization_form])

      if auth.valid?
        auth_token = auth.authorize!

        if auth.remember_authorization?
          add_premanent_authorization_token(auth_token)
        end

        self.authorization_token = auth_token

        redirect_to after_sign_in_path
      else
        @user_authentication_form = auth
        render 'new'
      end
    end
  end

  def destroy

  end
end
