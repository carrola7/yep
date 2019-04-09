class ApplicationController < ActionController::Base
  include Pagy::Backend
  helper_method :logged_in?, :current_user

  def current_user
    session[:user_id] && User.find(session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def require_user
    access_denied(login_path) unless logged_in?
  end

  def access_denied(path)
    flash[:danger] = "You must be logged in to do that"
    redirect_to path
  end

  def current_user?(user)
    user == current_user
  end
end
