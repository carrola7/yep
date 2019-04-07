require 'rails_helper'

feature 'User updates their profile' do
  context 'with valid inputs' do
    let(:bob) { Fabricate(:user, password: "password") }
    background { user_signs_in(bob) }

    scenario 'updates a review and displays a flash message' do
      new_user = Fabricate.attributes_for(:user)
      click_link("#{bob.name}")
      click_link("Update your profile")
      click_link("Cancel")
      click_link("Update your profile")
      fill_in :user_city, with: new_user[:city]
      fill_in :user_country, with: new_user[:country]
      fill_in :user_loves, with: new_user[:loves]
      click_button("Save Changes")
      expect(page).to have_content("You have updated your profile successfully.")
    end
  end
  context 'with invalid inputs' do
    let(:bob) { Fabricate(:user, password: "password") }
    background { user_signs_in(bob) }

    scenario 'shows a flash message and re-renders the page' do
      new_user = Fabricate.attributes_for(:user)
      click_link("#{bob.name}")
      click_link("Update your profile")
      fill_in :user_first_name, with: ""
      fill_in :user_city, with: new_user[:city]
      fill_in :user_country, with: new_user[:country]
      fill_in :user_loves, with: new_user[:loves]
      click_button("Save Changes")
      expect(page).to have_content("There was a problem with your inputs")
      expect(page).to have_content("can't be blank")
    end
  end
end