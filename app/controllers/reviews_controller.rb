class ReviewsController < ApplicationController
  before_action :require_user, only: [:create, :new, :edit, :update]

  def index
    @reviews = Review.all
  end

  def new
    @review = Review.new
    @review.business = Business.find(params[:business_id])
  end

  def edit
    @review = Review.find params[:id]
  end

  def show
    @review = Review.find params[:id]
  end

  def create
    @review = Review.new(review_params.merge(user: current_user))
    if @review.save
      flash[:success] = "Congratulations, you have added a new review!"
      redirect_to business_path(review_params[:business_id])
    else
      flash.now[:danger] = "There was an error with your inputs"
      render :new
    end
  end

  def update
    @review = Review.find params[:id]
    require_current_logged_in_user
    if @review.update(review_params)
      flash[:success] = "Review has been updated."
      redirect_to business_review_path(@review.business, @review)
    else
      flash[:danger] = "There was a problem with your inputs"
      render :edit
    end
  end

  private

  def review_params
    params.require(:review).permit([:rating, :body, :business_id])
  end

  def require_current_logged_in_user
    deny_update unless current_user_created_review?
  end

  def deny_update
    flash[:danger] = "You are not authorized to do that"
    redirect_to reviews_path
  end

  def current_user_created_review?
    @review.user == current_user
  end
end