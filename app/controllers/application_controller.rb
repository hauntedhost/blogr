class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    return nil unless session[:session_key].present?
    @current_user ||= User.find_by_session_key(session[:session_key])
  end

  def logged_in?
    current_user.present?
  end

  def require_user!
    redirect_to login_path unless logged_in?
  end
end
