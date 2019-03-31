class Business < ActiveRecord::Base
  validates_presence_of :name, :address_1, :city


  has_many :business_tags, inverse_of: :business
  has_many :tags, through: :business_tags
  has_many :reviews
  belongs_to :user

  def stars
    rating.floor
  end

  def half_star?
    rating.round > rating
  end

  def first_review_summary
    reviews.first&.body && reviews.first&.body[0..50] + "..."
  end

  private

  def rating
    return 0 if reviews.empty?
    ratings = reviews.map(&:rating).map(&:to_i)
    ratings.reduce(&:+) / ratings.size.to_f
  end
end