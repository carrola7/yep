class ReviewsController < ApplicationController
  before_action :require_user, only: [:create, :new, :edit, :update]

  def index
    @reviews = Review.all
  end

  def show
    @review = Review.find params[:id]
  end

  def new
    @review = Review.new
  end

  def edit
    @review = Review.find params[:id]
  end

  def create
    Review.create(review_params)
  end

  def update
  end

  private

  def review_params
    params.require(:review).permit([:rating, :body, :user_id, :business_id])
  end
end