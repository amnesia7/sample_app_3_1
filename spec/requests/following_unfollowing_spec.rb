require 'spec_helper'

describe "Following/Unfollowing" do
  
  before(:each) do
    user = Factory(:user)
    another_user = Factory(:user, :email => Factory.next(:email))
  	visit signin_path
  	fill_in :email,			:with => user.email
  	fill_in :password,	:with => user.password
  	click_button
  end

  it "should follow then unfollow a user" do
    visit user_path(2)
    click_button "Follow"
    visit root_path
    response.should have_selector('span#following', :content => "1 following")

    visit user_path(2)
    click_button "Unfollow"
    visit root_path
    response.should have_selector('span#following', :content => "0 following")
  end

end
