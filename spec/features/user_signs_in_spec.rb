require 'rails_helper'

feature 'User signs in' do
  scenario 'with valid credentials' do
    user_signs_in
    expect(page).to have_content "You are logged in"
  end

  scenario "when already signed in" do
    bob = Fabricate(:user, password: "password")
    user_signs_in(bob)
    visit login_path
    expect(page).to have_content(bob.name)
  end
end
