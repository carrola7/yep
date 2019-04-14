class PagesController < ApplicationController
  def front
    if logged_in?
      redirect_to businesses_path
    else
      @pagy, @reviews = pagy(Review.all)
      render layout: false
    end
  end
end
