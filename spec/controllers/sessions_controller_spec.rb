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
        session[:user_id] = Fabricate(:user).id
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
      it "sets the session user_id to the user's id" do
        expect(session[:user_id]).to eq(user.id)
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
end