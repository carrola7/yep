class UsersController < ApplicationController
  before_action :require_user, only: %i[show edit update]

  def new
    redirect_to home_path if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome, #{@user.first_name}"
      session[:user_slug] = @user.slug
      redirect_to login_path
    else
      flash.now[:danger] = 'There was a problem with your inputs'
      render :new
    end
  end

  def show
    @user = User.find_by(slug: params[:slug])
    @pagy, @reviews = pagy(@user.reviews)
  end

  def edit
    @user = User.find_by slug: params[:slug]
    if !current_user?(@user)
      access_denied(home_path)
    else
      render :edit
    end
  end

  def update
    @user = User.find_by slug: params[:slug]
    if !current_user?(@user)
      access_denied(home_path)
    else
      update_user
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :city, :country, :loves, :birthday_d, :birthday_m, :birthday_y)
  end

  def update_user
    if @user.update(user_params)
      flash[:success] = 'You have updated your profile successfully.'
      redirect_to user_path(@user)
    else
      flash.now[:danger] = 'There was a problem with your inputs'
      render :edit
    end
  end
end
