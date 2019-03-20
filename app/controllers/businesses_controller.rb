class BusinessesController < ApplicationController
  before_action :require_user, only: [:create, :new, :edit]

  def index
    @businesses = Business.all
  end

  def show
    @business = Business.find params[:id]
  end

  def create
    @business = Business.new(business_params.merge!(user: current_user))
    if @business.save
      flash[:success] = "Congratulations! You have added a new business."
      redirect_to businesses_path
    else
      flash.now[:danger] = "One or more inputs are invalid, please address the errors."
      render :new
    end
  end

  def new
    @business = Business.new
  end

  def update
  end

  private

  def business_params
    params.require(:business).permit([:name, :address_1, :address_2, :city, :country, :phone, :price])
  end
end