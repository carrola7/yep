class User < ActiveRecord::Base
  has_many :reviews
  has_many :businesses

  has_secure_password validations: false

  validates_presence_of :email, :password, :first_name, :last_name
  validates_uniqueness_of :email

  def name
    "#{first_name} #{last_name[0]}."
  end
end 