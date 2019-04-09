class Tag < ActiveRecord::Base
  validates_presence_of :name
  has_many :business_tags
  has_many :businesses, through: :business_tags

  def name=(s)
    write_attribute(:name, s.to_s.titleize) 
  end

end