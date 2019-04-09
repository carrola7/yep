require 'rails_helper'

feature 'User searches for a business' do
  context 'with search terms that exist' do
    let(:bob) { Fabricate(:user) }
    background do
      user_signs_in(bob)
    end

    scenario 'finds the correct business' do
      10.times { Fabricate(:business, user: bob) }
      Fabricate(:business, name: "Some business", city: "Dublin", user: bob)
      fill_in 'search_name', with: "Some"
      fill_in 'search_location', with: "Dub"
      find(:css, "button.input-group-append").click
      expect(page).to have_content("Showing 1 to 1 of 1")
    end
  end
  context 'with search terms that don\'t exist' do
    let(:bob) { Fabricate(:user) }
    background do
      user_signs_in(bob)
    end

    scenario 'finds the correct business' do
      10.times { Fabricate(:business, user: bob) }
      fill_in 'search_name', with: "Some"
      fill_in 'search_location', with: "Dub"
      find(:css, "button.input-group-append").click
      expect(page).to have_content("Sorry, no results found for Some Dub")
    end
  end
end