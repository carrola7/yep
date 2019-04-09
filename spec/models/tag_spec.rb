require 'rails_helper'

describe Tag do
  it { should validate_presence_of :name }
  it { should have_many :business_tags}
  it { should have_many(:businesses).through(:business_tags) }

  it "should save a name as a capitalized string" do
    Fabricate(:tag, name: 'some_name')
    expect(Tag.first.name).to eq('Some Name')
  end
end