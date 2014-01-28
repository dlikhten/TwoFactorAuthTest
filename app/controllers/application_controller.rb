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

  def log_off
    session[:current_user_id] = nil
  end

  def after_sign_in_path
    restore_path
  end

  def ensure_logged_in
    store_path
    redirect_to user_sessions_url if current_user.nil?
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
