require 'rails_helper'

feature 'Signing out' do
  scenario "User signs out when logged in" do
    user_signs_in
    click_link "Log Out"
    expect(page).to have_content "You have successfully logged out"
  end
end