require 'rails_helper'

describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_uniqueness_of :email }
  it { should have_many :reviews }
  it { should have_many :businesses }

  describe "#name" do
    context "with valid first name and last name" do
      let(:joe) { Fabricate(:user, first_name: "Joe", last_name: "Bloggs") }
      it "returns the first name and first initial of second name" do
        expect(joe.name).to eq("Joe B.")
      end
    end
  end

  describe "#location" do
    context "with city and country" do
      let(:joe) { Fabricate(:user, city: "Swords", country: "Ireland") }
      it "returns the correct location string" do
        expect(joe.location).to eq("Swords, Ireland")
      end
    end
    context "with country saved as an empty string" do
      let(:joe) { Fabricate(:user, city: "Swords", country: "") }
      it "returns city" do
        expect(joe.location).to eq("Swords")
      end
    end
    context "with city saved as an empty string" do
      let(:joe) { Fabricate(:user, city: "", country: "Ireland") }
      it "returns country" do
        expect(joe.location).to eq("Ireland")
      end
    end
    context "with city and country saved as nil" do
      let(:joe) { Fabricate(:user, city: nil, country: nil) }
      it "returns no location yet" do
        expect(joe.location).to be_nil
      end
    end
  end
end