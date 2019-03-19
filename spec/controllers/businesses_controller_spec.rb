require 'rails_helper'

describe BusinessesController do
  describe "GET index" do
    it "sets the @businesses variable" do
      get :index
      expect(assigns(:businesses)).to eq(Business.all)
    end
  end

  describe "GET show" do
    let(:some_business) { Fabricate.build(:business) }
    let(:bob) { Fabricate(:user) }
    before do
      some_business.user = bob
      some_business.save
    end
    it "sets the @business variable" do
      get :show, params: { id: some_business.id }
      expect(assigns(:business)).to eq(some_business)
    end
    it "renders the show template" do 
      get :show, params: { id: some_business.id }
      expect(response).to render_template :show
    end 
  end
end