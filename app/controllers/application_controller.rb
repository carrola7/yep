class ApplicationController < ActionController::Base
  helper_method :logged_in?, :current_user

  def current_user
    session[:user_id] && User.find(session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def require_user
    access_denied unless logged_in?
  end

  def access_denied
    flash[:danger] = "You must be logged in to do that"
    redirect_to login_path
  end
end
