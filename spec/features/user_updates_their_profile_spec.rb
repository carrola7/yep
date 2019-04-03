require 'rails_helper'

feature 'User updates their profile' do
  context 'with valid inputs' do
    let(:bob) { Fabricate(:user) }
    background { user_signs_in(bob) }

    scenario 'updates a review and displays a flash message' do
      visit home_path
      click_link("#{bob.name}")
    end
  end
end