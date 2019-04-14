class Review < ApplicationRecord
  include Sluggable

  validates :rating, presence: true
  validates :body, presence: true

  after_create :generate_slug


  belongs_to :user
  belongs_to :business
end
