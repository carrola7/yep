class ReviewsController < ApplicationController
  before_action :require_user, only: %i[create new edit update]

  def index
    @pagy, @reviews = pagy(Review.all)
  end

  def new
    @review = Review.new
    @review.business = Business.find(params[:business_id])
  end

  def edit
    @review = Review.find params[:id]
    if !current_user?(@review.user)
      access_denied(reviews_path)
    else
      render :edit
    end
  end

  def show
    @review = Review.find params[:id]
  end

  def create
    @review = Review.new(review_params.merge(user: current_user))
    @review.business = Business.find(params[:business_id])
    save_review
  end

  def update
    @review = Review.find params[:id]
    if !current_user?(@review.user)
      access_denied(reviews_path)
    else
      update_review
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :body, :business_id)
  end

  def update_review
    if @review.update(review_params)
      flash[:success] = 'Review has been updated.'
      redirect_to business_path(@review.business)
    else
      flash[:danger] = 'There was a problem with your inputs'
      render :edit
    end
  end

  def save_review
    if @review.save
      flash[:success] = 'Congratulations, you have added a new review!'
      redirect_to business_path(params[:business_id])
    else
      flash.now[:danger] = 'There was an error with your inputs'
      render :new
    end
  end
end
