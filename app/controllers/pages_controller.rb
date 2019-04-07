class PagesController < ApplicationController
  def front
    redirect_to businesses_path if logged_in?
  end
end