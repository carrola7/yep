class SessionsController < ApplicationController
  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You are logged in"
      redirect_to home_path
    else
      flash.now[:danger] = "There was a problem with your email and/or password"
      render :new
    end
  end
end