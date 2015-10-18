class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    if user && user.correct_password?(params[:password])
      user.reset_session_key!
      session[:session_key] = user.session_key
      redirect_to root_path, notice: 'Logged in'
    else
      flash.now[:error] = 'Invalid login'
      render :new
    end
  end

  def destroy
    user && user.destroy_session_key!
    reset_session
    redirect_to root_path
  end

  private

  def user
    @user ||= User.find_by_email(params[:email])
  end
end
