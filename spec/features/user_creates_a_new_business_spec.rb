require 'rails_helper'

feature 'User creates a new business' do
  context "with valid inputs" do
    background do
      user_signs_in
    end

    scenario 'fills in form correctly' do
      some_business = Fabricate.build(:business)
      click_link("See All Businesses")
      click_link("+ Add New Business")
      fill_in 'business_name', with: some_business.name
      fill_in 'business_address_1', with: some_business.address_1
      fill_in 'business_address_2', with: some_business.address_2
      fill_in 'business_city', with: some_business.city
      fill_in 'business_country', with: some_business.country
      fill_in 'business_phone', with: some_business.phone
      find('input[placeholder="e.g. Food"]').fill_in with: Fabricate.attributes_for(:tag)[:name]
      find('input[placeholder="e.g. Irish"]').fill_in with: Fabricate.attributes_for(:tag)[:name]
      click_button "Submit"
      expect(page).to have_content("Congratulations! You have added a new business.")
    end
  end
  context "with invalid inputs" do
    background do
      user_signs_in
    end

    scenario 'fills in form incorrectly' do
      some_business = Fabricate.build(:business)
      click_link("See All Businesses")
      click_link("+ Add New Business")
      fill_in 'business_address_1', with: some_business.address_1
      fill_in 'business_address_2', with: some_business.address_2
      fill_in 'business_city', with: some_business.city
      fill_in 'business_country', with: some_business.country
      fill_in 'business_phone', with: some_business.phone
      find('input[placeholder="e.g. Food"]').fill_in with: Fabricate.attributes_for(:tag)[:name]
      find('input[placeholder="e.g. Irish"]').fill_in with: Fabricate.attributes_for(:tag)[:name]
      click_button "Submit"
      expect(page).to have_content("One or more inputs are invalid, please address the errors.")
      expect(page).to have_content("can't be blank")
    end
  end

end