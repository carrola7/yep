require 'rails_helper'

feature 'User creates a new review' do
  context 'with valid inputs' do
    background do
      user_signs_in
    end

    scenario 'with valid inputs' do
      user_creates_a_review
      expect(page).to have_content("Congratulations, you have added a new review!")
      expect(Review.count).to eq 1
    end

    scenario 'with invalid inputs' do
      bob = Fabricate(:user)
      some_business = Fabricate(:business, user: bob)
      click_link "See All Reviews"
      click_link "+ Add New Review"
      click_link "Write A Review"
      within "select" do
        find("option[value='1']").select_option
      end
      click_button('Create Review')
      expect(page).to have_content("There was an error with your inputs")
      expect(Review.count).to eq 0
    end
  end
end
