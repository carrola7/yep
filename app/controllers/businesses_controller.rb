class BusinessesController < ApplicationController
  before_action :require_user, only: [:create, :new, :edit, :update]

  def index
    @businesses = Business.all
  end

  def show
    @business = Business.find params[:id]
  end

  def create
    @business = Business.new(business_params.merge!(user: current_user))
    add_tags_to_business if tag_params[:tags]
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

  def edit
    @business = Business.find params[:id]
  end

  def update
    @business = Business.find params[:id]
    if @business.update(business_params)
      update_business_tags if tag_params[:tags]
      flash[:success] = "Changes saved"
      redirect_to(business_path @business)
    else
      flash.now[:danger] =  "One or more inputs are invalid, please address the errors."
      render :edit
    end
  end

  private

  def business_params
    params.require(:business).permit([:name, :address_1, :address_2, :city, :country, :phone, :price])
  end

  def tag_params
    params.require(:business).permit([ {:tags => [:name] }])
  end

  def add_tags_to_business
    Business.transaction do
      tag_params[:tags].each do |tag_param| 
        unless tag_param[:name].blank?
          tag = Tag.find_by(name: tag_param[:name]) || Tag.create(tag_param)
          @business.tags << tag
        end
      end
    end
  end

  def update_business_tags
    @business.tags.clear
    add_tags_to_business
  end
end