class Review < ActiveRecord::Base
  validates_presence_of :rating
  validates_presence_of :body

  belongs_to :user
  belongs_to :business
end