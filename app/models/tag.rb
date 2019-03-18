class Tag < ActiveRecord::Base
  validates_presence_of :name
  has_one :business_tag
  has_many :businesses, through: :business_tag
end