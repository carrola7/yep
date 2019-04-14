class User < ApplicationRecord
  include Sluggable
  
  has_many :reviews, dependent: :destroy
  has_many :businesses, dependent: :nullify

  after_create :generate_slug

  has_secure_password

  validates :email, :first_name, :last_name, presence: true
  validates :password, presence: true, on: :create
  validates :email, uniqueness: true

  def name
    "#{first_name} #{last_name[0]}."
  end

  def location
    if city.present? && country.present?
      "#{city}, #{country}"
    else
      city.presence || country
    end
  end

  def since
    "#{Date::MONTHNAMES[created_at.month]} #{created_at.year}"
  end
end
