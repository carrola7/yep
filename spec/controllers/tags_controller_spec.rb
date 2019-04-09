require 'rails_helper'

describe TagsController do
  describe "GET show" do
    let(:tag) { Fabricate(:tag) }
    let(:bob) { Fabricate(:user) }
    before do
      3.times do
        business = Fabricate.build(:business, user: bob )
        business.tags << tag
        business.save
      end
      2.times { Fabricate(:business, user: bob) }
      get :show, params: { id: tag.id}
    end
    it "sets @businesses" do
      expect(assigns(:businesses)).to be_present
    end
    it "sets @tag" do
      expect(assigns(:tag)).to be_present
    end
    it "sets @businesses to a list of businesses of the correct size" do
      expect(assigns(:businesses).size).to eq(3)
    end
    it "renders the business index page" do
      expect(response).to render_template :show
    end
  end
end