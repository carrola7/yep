require 'rails_helper'

feature 'User creates a new business' do
  context "with valid inputs" do
    background do
      some_business = Fabricate.build(:business)
      user_signs_in
      click_link("See All Businesses")
      click_link("+ Add New Business")
      page.fill_in 'business_name', with: some_business.name
      page.fill_in 'business_address_1', with: some_business.address_1
      page.fill_in 'business_address_2', with: some_business.address_2
      page.fill_in 'business_city', with: some_business.city
      page.fill_in 'business_country', with: some_business.country
      page.fill_in 'business_phone', with: some_business.phone
      click_button "Submit"

    end
    scenario 'displays a successful flash message' do
      expect(page).to have_content("Congratulations! You have added a new business.")
    end
  end

end