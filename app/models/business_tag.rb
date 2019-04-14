class BusinessTag < ApplicationRecord
  belongs_to :tag
  belongs_to :business
end
