def user_signs_in(user = nil)
  user = user || Fabricate(:user, password: 'password')
  visit login_path
  fill_in :email, with: user.email
  fill_in :password, with: "password"
  click_button "Log in"
end

def user_creates_a_review
  bob = Fabricate(:user)
  some_business = Fabricate(:business, user: bob)
  click_link "See All Reviews"
  click_link "+ Add New Review"
  click_link "Write A Review"
  within "select" do
    find("option[value='1']").select_option
  end
  fill_in('Review', with: Fabricate.attributes_for(:review)[:body])
  click_button('Create Review')
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

