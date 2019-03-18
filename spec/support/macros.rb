def user_signs_in(user = nil)
  user = user || Fabricate(:user, password: 'password')
  visit login_path
  fill_in :email, with: user.email
  fill_in :password, with: "password"
  click_button "Log in"
end

