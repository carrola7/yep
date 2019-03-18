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
end