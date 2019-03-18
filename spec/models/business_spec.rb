require 'rails_helper'

describe Business do
  it { should validate_presence_of :name }
  it { should validate_presence_of  :address_1 }
  it { should validate_presence_of :city }
  it { should have_one :business_tag }
  it { should have_many(:tags).through(:business_tag) }
  it { should belong_to :user }
end