require 'rails_helper'

describe SettingsController do
  describe "GET edit" do
    context "when user is not logged in" do
      it_behaves_like "requires_signed_in_user" do
        let(:action) { get :edit, params: { id: Fabricate(:user).id } }
      end
    end
    context "when user logged in" do
      it "renders the edit page" do
        bob = Fabricate(:user)
        set_current_user(bob)
        get :edit, params: { id: bob.id }
        expect(response).to render_template(:edit)
      end
    end
    context "when user is logged in and tries to edit another user's setttings" do
      it "redirects to the home_path" do
        bob = Fabricate(:user)
        alice = Fabricate(:user)
        set_current_user(bob)
        get :edit, params: { id: alice.id }
        expect(response).to redirect_to home_path
      end
    end
  end

  describe "PUT update" do
    context "when user is not logged in" do
      it_behaves_like "requires_signed_in_user" do
        let(:action) { put :update, params: { id: Fabricate(:user).id } }
      end
    end
    context "when user is logged in" do
      let(:bob) { Fabricate(:user, password: "password") }
      context "with valid inputs" do
        before do
          set_current_user(bob)
          put :update, params: {id: bob.id, old_password: "password", password: "new_password", password_confirmation: "new_password"}
        end
        it "displays a flash message" do
          expect(flash[:success]).to be_present
        end
        it "redirects to the user's profile page" do
          expect(response).to redirect_to user_path(bob)
        end
      end
      context "with invalid inputs" do
        let(:bob) { Fabricate(:user, password: "password") }
        context "with new password mismatch" do
          before do
            set_current_user(bob)
            put :update, params: {id: bob.id, old_password: "password", password: "new_password", password_confirmation: "new_password1"}
          end
          it "displays a flash error message" do
            expect(flash.now[:danger]).to be_present
          end
          it "renders the edit page" do
            expect(response).to render_template :edit
          end
        end
        context "with old password incorrect" do
          before do
            set_current_user(bob)
            put :update, params: {id: bob.id, old_password: "password1", password: "new_password", password_confirmation: "new_password"}
          end
          it "displays a flash error message" do
            expect(flash.now[:danger]).to be_present
          end
          it "renders the edit page" do
            expect(response).to render_template :edit
          end
        end
      end
    end
  end
end