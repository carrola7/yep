require 'rails_helper'

describe Tag do
  it { should validate_presence_of :name }
  it { should have_one :business_tag}
  it { should have_many(:businesses).through(:business_tag) }
end