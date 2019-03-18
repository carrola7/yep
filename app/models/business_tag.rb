class BusinessTag < ActiveRecord::Base
  belongs_to :tag
  belongs_to :business
end