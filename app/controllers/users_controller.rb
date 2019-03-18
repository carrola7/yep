class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome, #{@user.first_name}"
      session[:user_id] = @user.id
      redirect_to login_path
    else
      flash.now[:danger] = "There was a problem with your inputs"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :birthday_d, :birthday_m, :birthday_y)
  end
end