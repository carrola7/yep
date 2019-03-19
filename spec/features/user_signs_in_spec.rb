require 'rails_helper'

feature 'User signs in' do
  scenario 'with valid credentials shows the logged in flash message' do
    user_signs_in
    expect(page).to have_content "You are logged in"
  end
end
