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

  describe "GET new" do
    let(:bob) { Fabricate(:user) }
    let(:some_business) { Fabricate(:business, user: bob) }
    it_behaves_like "requires_signed_in_user" do
      let(:action) { get :new, params: { business_id: some_business.id } }
    end
    before do 
      set_current_user
      get :new, params: { business_id: some_business.id }
    end
    it "sets @review" do
      expect(assigns(:review)).to be_instance_of(Review)
    end
    it "sets @review to be a a resource of a business" do
      expect(assigns(:review).business).to eq(some_business)
    end
    it "renders the :new template" do
      expect(response).to render_template :new
    end
  end

  describe "GET show" do
    before do
      bob = Fabricate(:user)
      some_business = Fabricate(:business, user: bob)
      some_review = Fabricate(:review, user: bob, business: some_business)
      get :show, params: { id: some_review.id, business_id: some_business.id }
    end
    it "sets @review" do
      expect(assigns(:review)).to eq(Review.first)
    end
    it "renders the :show template" do
      expect(response).to render_template(:show)
    end
  end

  describe "GET edit" do
    it_behaves_like "requires_signed_in_user" do
      let(:bob) { Fabricate(:user) }
      let(:some_business) { Fabricate(:business, user: bob) }
      let(:some_review) { Fabricate(:review, user: bob, business: some_business) }
      let(:action) { get :edit, params: { id: Review.first.id, business_id: some_business.id } }
    end
    before do
      set_current_user
      some_business = Fabricate(:business, user: current_user)
      some_review = Fabricate(:review, user: current_user, business: some_business)
      get :edit, params: {business_id: some_business.id, id: some_review.id }
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
      let(:bob) { Fabricate(:user) }
      let(:some_business) { Fabricate(:business, user: bob) }
      let(:action) { post :create, params: { review: Fabricate.attributes_for(:review), business_id: some_business.id } }
    end
    context "with authenticated users" do
      before { set_current_user }
      context "with valid input" do
        let(:some_business) { Fabricate(:business, user: current_user) }
        let(:some_review) { Fabricate.attributes_for(:review, business: some_business) }
        before do
          post :create, params: { review: some_review, business_id: some_business.id }
        end
        it "creates a new review" do
          expect(Review.count).to eq 1
        end
        it "creates a new review associated with the current user" do
          expect(Review.first.user).to eq(current_user)
        end
        it "displays a flash message" do
          expect(flash[:success]).to be_present
        end
        it "redirects to the show business page" do
          expect(response).to redirect_to business_path(Business.first)
        end
      end
      context "with invalid input" do
        let(:some_review) { Fabricate.attributes_for(:review, rating: nil, user: current_user) }
        let(:some_business) { Fabricate(:business, user: current_user) }
        before do
          post :create, params: { review: some_review, business_id: some_business.id }
        end
        it "does not create a new review" do
          expect(Review.count).to eq(0)
        end
        it "displays an error flash message" do
          expect(flash[:danger]).to be_present
        end
        it "sets @review" do
          expect(assigns(:review)).to be_instance_of(Review)
        end
        it "sets @review associated with a business" do
          expect(assigns(:review).business).to be_instance_of Business
        end
        it "renders the :new template" do
          expect(response).to render_template :new
        end
      end
    end
  end

  describe "PUT update" do
    context "when user not signed in" do
      before do
      end
      it_behaves_like "requires_signed_in_user" do
        let(:bob) { Fabricate(:user) }
        let(:some_business) { Fabricate(:business, user: bob) }
        let(:action) { put :update, params: {id: 1, review: Fabricate.attributes_for(:review), business_id: some_business.id } }
      end
    end
    context "with user signed in" do
      let(:bob) { Fabricate(:user) }
      let(:some_business) { Fabricate(:business, user: bob) }
      let(:some_review) { Fabricate(:review, business: some_business, user: bob) }
      context "with valid inputs" do
        let(:another_review) { Fabricate.attributes_for(:review) }
        before do
          set_current_user(bob)
          put :update, params: { review: another_review, id: some_review.id, business_id: some_business.id }
        end
        it "amends a review" do
          expect(Review.first.body).to eq(another_review[:body])
        end
        it "redirects to the show business page" do
          expect(response).to redirect_to business_review_path(some_business, some_review)
        end
        it "displays a flash message" do
          expect(flash[:success]).to be_present
        end
      end
      context "with invalid inputs" do
        before do
          set_current_user(bob)
          put :update, params: { review: { rating: nil}, id: some_review.id, business_id: some_business.id }
        end
        it "displays a flash error message" do
          expect(flash[:danger]).to be_present
        end
        it "sets @business" do
          expect(assigns(:review)).to eq(some_review)
        end
        it "renders the :edit template" do
          expect(response).to render_template :edit
        end
      end
      context "with user who didn't create the review" do
        let(:another_review) { Fabricate.attributes_for(:review) }
        before do
          set_current_user
          put :update, params: { review: another_review, id: some_review.id, business_id: some_business.id }
        end
        it "doesn't change the review" do
          expect(Review.first.body).to eq(some_review.body)
        end
        it "sets a flash message" do
          expect(flash[:danger]).to be_present
        end
        it "redirects to the reviews path" do
          expect(response).to redirect_to reviews_path
        end
      end
    end
  end
end