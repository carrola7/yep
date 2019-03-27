require 'rails_helper'

describe ReviewsController do
  describe "GET index" do
    before { get :index }
    it "sets @reviews" do
      expect(assigns(:reviews)).to eq(Review.all)
    end
    it "renders the :index template" do
      expect(response).to render_template(:index)
    end
  end

  describe "GET show" do
    before do
      bob = Fabricate(:user)
      some_business = Fabricate(:business, user: bob)
      some_review = Fabricate(:review, user: bob, business: some_business)
      get :show, params: { id: some_review.id }
    end
    it "sets @review" do
      expect(assigns(:review)).to eq(Review.first)
    end
    it "renders the :show template" do
      expect(response).to render_template(:show)
    end
  end

  describe "GET new" do
    it_behaves_like "requires_signed_in_user" do
      let(:action) { get :new }
    end
    before do 
      set_current_user
      get :new
    end
    it "sets @review" do
      expect(assigns(:review)).to be_instance_of(Review)
    end
    it "renders the :new template" do
      expect(response).to render_template :new
    end
  end

  describe "GET edit" do
    it_behaves_like "requires_signed_in_user" do
      let(:action) { get :edit, params: { id: 1 } }
    end
    before do
      set_current_user
      some_business = Fabricate(:business, user: current_user)
      some_review = Fabricate(:review, user: current_user, business: some_business)
      get :edit, params: { id: some_review.id }
    end
    it "sets @review" do
      expect(assigns(:review)).to eq(Review.first)
    end
    it "renders the :edit template" do
      expect(response).to render_template :edit
    end
  end

  describe "POST create" do
    it_behaves_like "requires_signed_in_user" do
      let(:action) { post :create, params: { review: Fabricate.attributes_for(:review) } }
    end
    context "with authenticated users" do
      before { set_current_user }
      context "with valid input" do
        let(:some_business) { Fabricate(:business, user: current_user) }
        let(:some_review) { Fabricate.attributes_for(:review, user: current_user, business: some_business) }
        before do
          post :create, params: { review: some_review }
        end
        it "creates a new review" do
          expect(Review.count).to eq 1
        end
        it "creates a new review associated with the current user"
        it "displays a flash message"
        it "redirects to the show business page"
      end
      context "with invalid input" do
        it "does not create a new review"
        it "displays an error flash message"
        it "sets @review"
        it "renders the :new template"
      end
    end
  end

  describe "PUT update" do
    context "when user not signed in" do
      before do
      end
      it_behaves_like "requires_signed_in_user" do
        let(:action) { put :update, params: {id: 1, review: Fabricate.attributes_for(:review) } }
      end
    end
    context "with user signed in" do
      context "with valid inputs" do
        it "amends a review"
        it "redirects to the show business page"
        it "displays a flash message"
      end
      context "with invalid inputs" do
        it "displays a flash error message"
        it "sets @business"
        it "renders the :edit template"
      end
    end
  end
end