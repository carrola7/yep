require 'rails_helper'

describe BusinessesController do
  describe "GET index" do
    it "sets @businesses" do
      get :index
      expect(assigns(:businesses)).to eq(Business.first 10)
    end
    it "renders the index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET show" do
    let(:some_business) { Fabricate.build(:business) }
    let(:bob) { Fabricate(:user) }
    before do
      some_business.user = bob
      some_business.save
    end
    it "sets @business" do
      get :show, params: { slug: some_business.slug }
      expect(assigns(:business)).to eq(some_business)
    end
    it "sets @reviews" do
      get :show, params: { slug: some_business.slug }
      expect(assigns(:reviews)).to eq(some_business.reviews.first 10)
    end
    it "renders the show template" do 
      get :show, params: { slug: some_business.slug }
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
      let(:action) { get :edit, params: { slug: 1} }
    end
    context "with authenticated user" do
      before do
        set_current_user
        post :create, params: { business: Fabricate.attributes_for(:business)}
      end
      it "sets @business" do
        get :edit, params: { slug: Business.first.slug }
        expect(assigns(:business)).to eq(Business.first)
      end
      it "renders the :edit page" do
        get :edit, params: { slug: Business.first.slug }
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
        let(:action) { put :update, params: { slug: Business.first.slug, business: Fabricate.attributes_for(:business)}}
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
          put :update, params: {slug: Business.first.slug, business: some_other_business}
          expect(Business.first.name).to eq(some_other_business[:name])
        end
        it "redirects to the show business page" do
          some_other_business = Fabricate.attributes_for(:business)
          put :update, params: {slug: Business.first.slug, business: some_other_business}
          expect(response).to redirect_to business_path(Business.first)
        end
        it "displays a flash message" do
          some_other_business = Fabricate.attributes_for(:business)
          put :update, params: {slug: Business.first.slug, business: some_other_business}
          expect(flash[:success]).to eq("Changes saved")
        end
      end
      context "with one tag" do
        let(:business_params) { Fabricate.attributes_for(:business) }
        let(:tag) { Fabricate.attributes_for(:tag) }
        before do
          set_current_user
          business_params[:tags] = [tag]
          post :create, params: { business: business_params }
        end
        it "updates the business' tag" do
          new_tag = Fabricate.attributes_for(:tag)
          business_params[:tags] = [new_tag]
          put :update, params: { slug: Business.first.slug, business: business_params }
          expect(Business.first.tags.first.name).to eq(new_tag[:name].titleize)
        end
      end
      context "with multiple tags" do
        let(:business_params) { Fabricate.attributes_for(:business) }
        let(:tag_1) { Fabricate.attributes_for(:tag) }
        let(:tag_2) { Fabricate.attributes_for(:tag) }
        let(:tag_3) { Fabricate.attributes_for(:tag) }

        before do
          set_current_user
          business_params[:tags] = [tag_1, tag_2, tag_3]
          post :create, params: { business: business_params }
        end
        it "updates the business' tags" do
          new_tags = Array.new(3).map { Fabricate.attributes_for(:tag) }

          put :update, params: { slug: Business.first.slug, :business => {tags: new_tags} }
          expect(new_tags.map{|n| n[:name]}).to include(new_tags.first[:name])
        end
      end
      context "with invalid inputs" do
        let(:tag) { Fabricate(:tag) }
        before do
          set_current_user
          post :create, params: { business: Fabricate.attributes_for(:business) }
        end
        it "displays a flash[:danger] message" do
          put :update, params: {slug: Business.first.slug, business: { name: nil }}
          expect(flash[:danger]).to be_present
        end
        it "sets @business" do
          put :update, params: {slug: Business.first.slug, business: { name: nil }}
          expect(assigns(:business)).to eq(Business.first)
        end
        it "renders the :edit template" do
          put :update, params: {slug: Business.first.slug, business: { name: nil }}
          expect(response).to render_template(:edit)
        end
        it "doesn't update the tags" do
          put :update, params: { slug: Business.first.slug, business: { tags: [{ name: tag.name}] } }
          put :update, params: { slug: Business.first.slug, business: { name: nil, tags: [{ name: "foo"} ] } }
          expect(Business.first.tags.map(&:name)).not_to include("foo")
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
      context "with tags" do
        let(:business_params) { Fabricate.attributes_for(:business) }
        let(:other_business_params) { Fabricate.attributes_for(:business) }

        it "creates new tag when one tag attached" do
          business_params[:tags] =  [ Fabricate.attributes_for(:tag) ] 
          post :create, params: { business: business_params }
          expect(Tag.count).to eq(1)
        end
        it "creates new tags when multiple tags attached" do
          business_params[:tags] =  Array.new(3).map { Fabricate.attributes_for(:tag) } 
          post :create, params: { business: business_params }
          expect(Tag.count).to eq(3)
        end
        it "doesn't create a new tag if the tag name already exists" do
          tag = Fabricate.attributes_for(:tag)
          business_params[:tags] = [tag]
          post :create, params: { business: business_params }

          other_business_params[:tags] = [tag]
          post :create, params: { business: other_business_params }

          expect(Tag.count).to eq(1)
        end
        it "doesn't create multiple tags if all tag inputs have the same name" do
          tag = Fabricate.attributes_for(:tag)
          business_params[:tags] = [tag, tag, tag]
          post :create, params: { business: business_params }

          expect(Tag.first.businesses.count).to eq(1)
        end
        it "creates tags associated with the business" do
          business_params[:tags] =  Array.new(3).map { Fabricate.attributes_for(:tag) } 
          post :create, params: { business: business_params }
          expect(Business.first.tags).to include(Tag.first)
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

  describe "GET search" do
    context "including business name only" do
      let(:bob) { Fabricate(:user) }
      before do
        Fabricate(:business, name: "some business", user: bob)
      end
      it "sets @businesses" do
        get "search", params: { search_name: "some" }
        expect(assigns(:businesses)).to eq([Business.first])
      end
      it "renders :search" do
        get "search", params: { search_name: "some" }
        expect(response).to render_template(:search)
      end
      it "returns the correct business" do
        another_business = Fabricate(:business, name: "another business", user: bob)
        get "search", params: { search_name: "anoth" }
        expect(assigns(:businesses)).to eq([another_business])
      end
    end
    context "including location only" do
      let(:bob) { Fabricate(:user) }
      before do
        Fabricate(:business, city: "Dublin", user: bob)
      end
      it "sets @businesses" do
        get "search", params: { search_location: "Dub" }
        expect(assigns(:businesses)).to eq([Business.first])
      end
      it "returns the correct business for city name match" do
        another_business = Fabricate(:business, city: "London", user: bob)
        get "search", params: { search_location: "Lon" }
        expect(assigns(:businesses)).to eq([another_business])
      end
    end
    context "including business name and location" do
      let(:bob) { Fabricate(:user) }
      before do
        Fabricate(:business, name: "some business", city: "Dublin", user: bob)
        Fabricate(:business, name: "another business", city: "Dublin", user: bob)
        Fabricate(:business, name: "some business", city: "London", user: bob)
      end
      it "sets @businesses to the correct array" do
        get "search", params: { search_name: "some", search_location: "Dub" }
        expect(assigns(:businesses)).to eq([Business.first])
      end
      it "sets @businesses to the correct array and accounts for whitespace" do
        get "search", params: { search_name: "  some ", search_location: " Dub" }
        expect(assigns(:businesses)).to eq([Business.first])
      end
    end
  end
end
