require 'rails_helper'

describe Business do
  it { should validate_presence_of :name }
  it { should validate_presence_of  :address_1 }
  it { should validate_presence_of :city }
  it { should have_many :business_tags }
  it { should have_many :reviews }
  it { should have_many(:tags).through(:business_tags) }
  it { should belong_to :user }

  describe "stars" do
    it "returns an integer based on the reviews" do
      bob = Fabricate(:user)
      some_business = Fabricate(:business, user: bob)
      [4, 5].each { |n| Fabricate(:review, user: bob, business: some_business, rating: n)}
      expect(Business.first.stars).to eq(4)
    end
    it "returns 0 if there are no reviews" do
      bob = Fabricate(:user)
      some_business = Fabricate(:business, user: bob)
      expect(Business.first.stars).to eq(0)
    end
  end

  describe "half_star?" do
    it "returns true if the rating has a decimal >= 0.5" do
      bob = Fabricate(:user)
      some_business = Fabricate(:business, user: bob)
      [4, 5].each { |n| Fabricate(:review, user: bob, business: some_business, rating: n)}
      expect(Business.first.half_star?).to be true
    end

    it "returns false if the rating has a decimal < 0.5" do
      bob = Fabricate(:user)
      some_business = Fabricate(:business, user: bob)
      [4, 5, 1].each { |n| Fabricate(:review, user: bob, business: some_business, rating: n)}
      expect(Business.first.half_star?).to be false
    end

    it "returns false if there are no reviews" do
      bob = Fabricate(:user)
      some_business = Fabricate(:business, user: bob)
      expect(Business.first.half_star?).to be false      
    end
  end
end