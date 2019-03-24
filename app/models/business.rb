class Business < ActiveRecord::Base
  validates_presence_of :name, :address_1, :city


  has_many :business_tags
  has_many :tags, through: :business_tags
  belongs_to :user
end