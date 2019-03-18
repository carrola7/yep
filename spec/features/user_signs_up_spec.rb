require 'rails_helper'

feature 'User signs up' do
  scenario 'with valid credentials' do
    user = Fabricate.build(:user)
    visit register_path

    find('input[placeholder="Email"]').fill_in with: user.email
    find('input[placeholder="Password"]').fill_in with: user.password
    find('input[placeholder="First Name"]').fill_in with: user.first_name
    find('input[placeholder="Last Name"]').fill_in with: user.last_name
    find('input[placeholder="City/Town"]').fill_in with: user.city
    select(user.birthday_d.to_s, from: 'Birthday d')
    select(user.birthday_m, from: 'Birthday m')
    select(user.birthday_y.to_s, from: 'Birthday y')

    find_button(class: ["btn", "btn-block", "btn-danger", "my-4"]).click
    expect(page).to have_content "Welcome, #{user.first_name}"
  end

  scenario 'with invalid credentials' do
    user = Fabricate.build(:user)
    visit register_path

    find('input[placeholder="Email"]').fill_in with: user.email

    find_button(class: ["btn", "btn-block", "btn-danger", "my-4"]).click
    expect(page).to have_content "can't be blank"
  end
end
