def user_signs_in(user = nil)
  user = user || Fabricate(:user, password: 'password')
  visit login_path
  fill_in :email, with: user.email
  fill_in :password, with: "password"
  click_button "Log in"
end

def set_current_user(user = nil)
  bob = user ? user : Fabricate(:user)
  session[:user_id] = bob.id
end

def clear_current_user
  session[:user_id] = nil
end

def current_user
  User.find(session[:user_id])
end

