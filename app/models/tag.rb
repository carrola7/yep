class Tag < ApplicationRecord
  validates :name, presence: true
  has_many :business_tags, dependent: :destroy
  has_many :businesses, through: :business_tags

  def name=(str)
    self[:name] = str.to_s.titleize
  end
end
