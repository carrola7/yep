class Business < ActiveRecord::Base
  validates_presence_of :name, :address_1, :city


  has_many :business_tags, inverse_of: :business
  has_many :tags, through: :business_tags
  belongs_to :user

  accepts_nested_attributes_for :tags, allow_destroy: true
end