class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  private

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

  def send_csv(data)
    send_data(
      data.to_csv,
      type: 'text/csv; charset=utf8; header=present',
      disposition: 'attachment; filename=articles.csv'
    )
  end

  def login_user!

  end
end
