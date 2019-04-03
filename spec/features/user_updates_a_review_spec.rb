require 'rails_helper'

feature 'User updates an existing review' do
  context 'with valid inputs' do
    background do
      user_signs_in
    end

    scenario 'updates a review' do
      user_creates_a_review
      click_link("Edit")
      within "select" do
        find("option[value='1']").select_option
      end
      fill_in('Review', with: Fabricate.attributes_for(:review)[:body])
      click_button('Update Review')
      expect(page).to have_content("Review has been updated")
    end
  end

  context "with invalid inputs" do
    background do
      user_signs_in
      user_creates_a_review
      click_link("Edit")
      within "select" do
        find("option[value='1']").select_option
      end
      fill_in('Review', with: nil)
      click_button('Update Review')
    end
    scenario "displays an error message" do
      expect(page).to have_content("There was a problem with your inputs")
    end
    scenario "renders the :edit template" do
      expect(page).to have_content("Edit review for #{Business.first.name}")
    end
  end
end
