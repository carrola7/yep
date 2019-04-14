require 'rails_helper'

describe SessionsController do
  describe "GET new" do
    context "when user is not logged in" do
      it "renders the :new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end
    
    context "when user is logged in" do
      before do
        session[:user_slug] = Fabricate(:user).slug
      end
      it "redirects to the home path" do
        get :new
        expect(response).to redirect_to(home_path)
      end
    end
  end

  describe "POST create" do
    context "with valid credentials" do
      let(:user) { Fabricate(:user) }
      before do
        post :create, params: { email: user.email, password: user.password }
      end
      it "sets the session user_slug to the user's slug" do
        expect(session[:user_slug]).to eq(user.slug)
      end
      it { is_expected.to respond_with 302}
    end
    context "with invalid credentials" do
      let(:user) { Fabricate.build(:user) }
      before do
        post :create, params: { email: user.email, password: user.password }        
      end
      it "displays an error message" do
        expect(flash[:danger]).to be_present
      end
      it "renders the new template" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET destroy" do
    context "when user is logged in" do
      let(:bob) { Fabricate(:user )}
      before do
        post :create, params: { email: bob.email, password: bob.password }
      end
      it "deletes the user_slug from the session" do
        get :destroy
        expect(session[:user_slug]).to be_nil
      end
      it "sets the flash message" do
        get :destroy
        expect(flash[:success]).to be_present
      end
      it "redirects to the home path" do
        get :destroy
        expect(response).to redirect_to(root_path)
      end
    end

    context "when user is not logged in" do
      it "does not set a flash message" do
        get :destroy
        expect(flash[:success]).to_not be_present
      end
    end
  end
end