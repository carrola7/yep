require 'rails_helper'

describe UsersController do
  describe "GET new" do
    it "sets the @user variable" do
      get :new
      expect(assigns :user).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid input" do
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

    context "with invalid input" do
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
end