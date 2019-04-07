class User < ActiveRecord::Base
  has_many :reviews
  has_many :businesses

  has_secure_password# validations: false

  validates_presence_of :email, :first_name, :last_name
  validates_presence_of :password, on: :create
  validates_uniqueness_of :email

  def name
    "#{first_name} #{last_name[0]}."
  end

  def location
    if !city.blank? && !country.blank?
      "#{city}, #{country}"
    else
      city.blank? ? country : city
    end
  end

  def since
    "#{Date::MONTHNAMES[created_at.month]} #{created_at.year}"
  end
end 