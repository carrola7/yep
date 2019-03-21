class Business < ActiveRecord::Base
  validates_presence_of :name, :address_1, :city


  has_one :business_tag
  has_many :tags, through: :business_tag
  belongs_to :user
end