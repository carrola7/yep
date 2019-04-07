require 'rails_helper'

feature 'User changes their password' do
  background do
    user_signs_in
    click_link("Account Settings")
    fill_in :password, with: "new_password"
  end
  context "with valid inputs" do

    scenario "displays a success flash message" do
      fill_in :old_password, with: "password"
      fill_in :password_confirmation, with: "new_password"
      click_button "Save New Password"
      expect(page).to have_content("Your password has been updated")
    end
  end
  context "with incorrect password" do

    scenario "displays a success flash error message" do
      fill_in :old_password, with: "pass"
      fill_in :password_confirmation, with: "new_password"
      click_button "Save New Password"
      expect(page).to have_content("Password incorrect, please try again")
    end
  end
  context "with passwords that don't match" do

    scenario "displays a success flash error message" do
      fill_in :old_password, with: "password"
      fill_in :password_confirmation, with: "new_password1"
      click_button "Save New Password"
      expect(page).to have_content("New password did not match password confirmation, please try again")
    end
  end
end