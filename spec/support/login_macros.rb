module LoginMacros
  def login_user(user)
    user.reset_session_key!
    session[:session_key] = user.session_key
  end
end
