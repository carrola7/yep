class SettingsController < ApplicationController
  before_action :require_user, only: %i[edit update]
  before_action :require_signed_in_user, only: :edit

  def update
    @user ||= User.find params[:id]
    if @user.authenticate(old_password)
      update_password
    else
      flash.now[:danger] = 'Password incorrect, please try again.'
      render :edit
    end
  end

  def edit; end

  private

  def require_signed_in_user
    @user ||= User.find params[:id]
    redirect_to home_path unless @user == current_user
  end

  def new_password
    { password: params[:password], password_confirmation: params[:password_confirmation] }
  end

  def old_password
    params[:old_password]
  end

  def update_password
    if @user.update(new_password)
      flash[:success] = 'Your password has been updated'
      redirect_to user_path(@user)
    else
      flash.now[:danger] = 'New password did not match password confirmation, please try again.'
      render :edit
    end
  end
end
