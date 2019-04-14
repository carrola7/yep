require 'rails_helper'

describe UsersController do
  describe "GET new" do
    it "sets the @user variable" do
      get :new
      expect(assigns :user).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valslug input" do
      before do
        post :create, params: { user: Fabricate.attributes_for(:user) }
      end
      it "saves a new user" do
        expect(User.count).to eq(1)
      end

      it "redirects to the sign in page" do
        expect(response).to redirect_to(login_path)
      end
    end

    context "with invalslug input" do
      before do
        post :create, params: { user: Fabricate.attributes_for(:user, password: "") }
      end

      it "does not create the user" do
        expect(User.first).to be_nil
      end

      it "renders the new template" do
        expect(response).to render_template(:new)
      end

      it "sets @user" do
        expect(assigns :user).to be_instance_of(User)
      end
    end
  end

  describe "GET show" do
    it_behaves_like "requires_signed_in_user" do
      let(:bob) { Fabricate(:user) }
      let(:action) { get :show, params: { slug: bob.slug }}
    end
    let(:bob) { Fabricate(:user) }
    before do
      set_current_user(bob)
      get :show, params: { slug: bob.slug }
    end
    it "assigns @user" do
      expect(assigns(:user)).to eq(bob)
    end
    it "renders the :show template" do
      expect(response).to render_template :show
    end
  end

  describe "GET edit" do
    it_behaves_like "requires_signed_in_user" do
      let(:bob) { Fabricate(:user) }
      let(:action) { get :edit, params: { slug: bob.slug }}
    end
    context "with current user accessing their own profile" do
      let(:bob) { Fabricate(:user) }
      before do
        set_current_user(bob)
        get :edit, params: { slug: bob.slug }
      end
      it "assigns @user" do
        expect(assigns(:user)).to eq(bob)
      end
      it "renders the :edit page" do
        expect(response).to render_template(:edit)
      end
    end
    context "with current user accessing someone else's profile" do
      let(:bob) { Fabricate(:user) }
      let(:alice) { Fabricate(:user) }
      before do
        set_current_user(bob)
        get :edit, params: { slug: alice.slug }
      end
      it "displays a flash message" do
        expect(flash[:danger]).to be_present
      end
      it "redirects to the home page" do
        expect(response).to redirect_to home_path
      end
    end
  end

  describe "PUT update" do
    it_behaves_like "requires_signed_in_user" do
      let(:bob) { Fabricate(:user) }
      let(:action) { put :update, params: { slug: bob.slug, user: { city: Fabricate.attributes_for(:user)[:city] }}}
    end
    context "with current user updating their own profile" do
      let(:bob) { Fabricate(:user) }
      let(:city) { Fabricate.attributes_for(:user)[:city] }
      context "with valslug inputs" do
        before do
          set_current_user(bob)
          put :update, params: { slug: bob.slug, user: { city: city}}
        end
        it "saves the changes" do
          expect(User.first.city).to eq(city)
        end
        it "displays a flash message" do
          expect(flash[:success]).to be_present
        end
        it "redirects to the show profile page" do
          expect(response).to redirect_to user_path(bob)
        end
      end
      context "with invalslug inputs" do
        before do
          set_current_user(bob)
          put :update, params: { slug: bob.slug, user: { email: nil}}
        end
        it "does not save the changes" do
          expect(User.first.city).not_to be_nil
        end
        it "assigns @user" do
          expect(assigns(:user)).to be_present
        end
        it "displays a flash message" do
          expect(flash.now[:danger]).to be_present
        end
        it "renders the :edit page" do
          expect(response).to render_template(:edit)
        end
      end
    end
    context "with current user updating someone else's profile" do
      let(:bob) { Fabricate(:user) }
      let(:alice) { Fabricate(:user) }
      let(:city) { Fabricate.attributes_for(:user)[:city] }
      before do
        set_current_user(bob)
        put :update, params: { slug: alice.slug, user: { city: city}}
      end
      it "displays a flash message" do
        expect(flash[:danger]).to be_present
      end
      it "redirects to the home page" do
        expect(response).to redirect_to home_path
      end
    end
  end
end