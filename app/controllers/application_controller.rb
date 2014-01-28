class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user=(new_current_user)
    session[:current_user_id] = new_current_user.id
  end

  def current_user
    @current_user ||= User.find_by_id(session[:current_user_id]) if session[:current_user_id]
  end

  def current_user_authentication
    @authentication_token ||= UserAuthorization.find_for_user(current_user, session[:current_authorization_token])
  end

  def log_off
    reset_session
  end

  def after_sign_in_path
    restore_path
  end

  def add_premanent_authorization_token(token)
    # TODO: implement me
  end

  def authorization_token=(token)
    session[:current_authorization_token] = token.token
  end

  def ensure_logged_in
    store_path

    ensure_login_exists
  end

  def ensure_authorized
    ensure_login_authorized if ensure_logged_in
  end

  def ensure_login_exists
    if current_user.nil?
      redirect_to user_sessions_url
      false
    else
      true
    end
  end

  def ensure_login_authorized
    if current_user_authentication.blank?
      redirect_to user_authorizations_url
      false
    else
      true
    end
  end

  def ensure_not_authorized
    if current_user_authentication.blank?
      true
    else
      redirect_to root_url
    end
  end

  def store_path
    session[:return_to] = request.fullpath
  end

  def restore_path
    return_to = session[:return_to] || root_path
    session[:return_to] = nil

    return_to
  end
end
