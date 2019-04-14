class Business < ApplicationRecord
  include Sluggable

  validates :name, :address_1, :city, presence: true
  after_create :generate_slug

  has_many :business_tags, inverse_of: :business, dependent: :destroy
  has_many :tags, through: :business_tags
  has_many :reviews, dependent: :destroy
  belongs_to :user

  def self.search(params)
    if params[:location] && params[:name]
      search_for_name_and_location(params)
    elsif params[:location]
      search_for_location(params)
    else
      search_for_name(params)
    end
  end

  def stars
    rating.floor
  end

  def half_star?
    rating.round > rating
  end

  def first_review_summary
    reviews.first&.body && reviews.first.body[0..50] + '...'
  end

  def rating
    return 0 if reviews.empty?

    ratings = reviews.map(&:rating).map(&:to_i)
    ratings.reduce(&:+) / ratings.size.to_f
  end

  def self.search_for_name_and_location(params)
    Business.where('lower(name) LIKE ? AND lower(city) LIKE ?', "%#{params[:name].downcase}%", "%#{params[:location].downcase}%").order('created_at DESC')
  end

  def self.search_for_location(params)
    Business.where('lower(city) LIKE ?', "%#{params[:location].downcase}%").order('created_at DESC')
  end

  def self.search_for_name(params)
    Business.where('lower(name) LIKE ?', "%#{params[:name].downcase}%").order('created_at DESC')
  end
end
