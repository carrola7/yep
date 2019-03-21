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

  describe "GET new" do
    it_behaves_like "requires_signed_in_user" do
      let(:action) { get :new }
    end
    before { set_current_user }
    it "sets @business" do
      get :new
      expect(assigns(:business)).to be_instance_of(Business)
    end
  end

  describe "GET edit" do
    it_behaves_like "requires_signed_in_user" do
      let(:action) { get :edit, params: { id: 1} }
    end
    context "with authenticated user" do
      before do
        set_current_user
        post :create, params: { business: Fabricate.attributes_for(:business)}
      end
      it "sets @business" do
        get :edit, params: { id: Business.first.id }
        expect(assigns(:business)).to eq(Business.first)
      end
      it "renders the :edit page" do
        get :edit, params: { id: Business.first.id }
        expect(response).to render_template :edit
      end
    end
  end

  describe "PUT update" do
    context "with user not signed in" do
      before do
        set_current_user
        post :create, params: { business: Fabricate.attributes_for(:business) }
      end
      it_behaves_like "requires_signed_in_user" do
        let(:action) { put :update, params: { id: Business.first.id, business: Fabricate.attributes_for(:business)}}
      end
    end
    context "with user signed in" do
      context "with valid inputs" do
        before do
          set_current_user
          post :create, params: { business: Fabricate.attributes_for(:business) }
        end
        it "amends a business" do
          some_other_business = Fabricate.attributes_for(:business)
          put :update, params: {id: Business.first.id, business: some_other_business}
          expect(Business.first.name).to eq(some_other_business[:name])
        end
        it "redirects to the show business page" do
          some_other_business = Fabricate.attributes_for(:business)
          put :update, params: {id: Business.first.id, business: some_other_business}
          expect(response).to redirect_to business_path(Business.first)
        end
        it "displays a flash message" do
          some_other_business = Fabricate.attributes_for(:business)
          put :update, params: {id: Business.first.id, business: some_other_business}
          expect(flash[:success]).to eq("Changes saved")
        end
      end
      context "with invalid inputs" do
        before do
          set_current_user
          post :create, params: { business: Fabricate.attributes_for(:business) }
        end
        it "displays a flash[:danger] message" do
          put :update, params: {id: Business.first.id, business: {name: nil}}
          expect(flash[:danger]).to be_present
        end
        it "sets @business" do
          put :update, params: {id: Business.first.id, business: {name: nil}}
          expect(assigns(:business)).to eq(Business.first)
        end
        it "renders the edit page" do
          put :update, params: {id: Business.first.id, business: {name: nil}}
          expect(response).to render_template(:edit)
        end
      end
    end
  end
  
  describe "POST create" do
    it_behaves_like "requires_signed_in_user" do
      let(:action) { post :create, params: { business: Fabricate.attributes_for(:business) }}
    end
    context "with authenticated users" do
      before { set_current_user }         
      context "with valid input" do
        before do
          post :create, params: { business: Fabricate.attributes_for(:business) }
        end
        it "creates a new business" do
          expect(Business.count).to eq(1)
        end
        it "creates a business associated with the current signed in user" do
          expect(Business.first.user).to eq(current_user)
        end
        it "displays a success flash message" do
          expect(flash[:success]).to be_present
        end
        it "redirects to the business page" do
          expect(response).to redirect_to(businesses_path)
        end
      end
      context "with invalid input" do
        before do
          post :create, params: { business: {address_1: "foo"}}
        end
        it "does not create a new business" do
          expect(Business.count).to eq(0)
        end
        it "displays an error flash message" do
          expect(flash[:danger]).to be_present
        end
        it "sets @business" do
          expect(assigns(:business)).to be_instance_of(Business)
        end
        it "renders the :new template" do
          expect(response).to render_template(:new)
        end
      end
    end
  end
end