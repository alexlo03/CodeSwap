Given /^I am not logged in$/ do
  visit 'root'
end

Given /^I have an account$/ do
  u = User.new(:email => 'test@test.com', :password => 'password')
  u.save
end

When /^I go to the sign up page$/ do
  visit 'users/sign_up'
end

When /^I go to the sign in page$/ do
  visit 'users/sign_in'
end

When /^I sign in$/ do
  fill_in "Email", :with => 'test@test.com'
  fill_in 'Password', :with => 'password'
  click_button 'Sign in'
end

When /^enter "([a-zA-Z]*)" information$/ do |role|
  fill_in "Email", :with => 'test@test.com'
  fill_in 'Password', :with => 'password'
  fill_in 'Password confirmation', :with => 'password'
  select role, :from => 'Role'
  click_button 'Sign up'
end

Then /^I should see "(.*)"$/ do |text|
  page.should have_content(text) 
end

When /^I log out$/ do
  click_link "Get me out of here!"
end

When /^enter bad passwords$/ do
  fill_in "Email", :with => 'test@test.com'
  fill_in 'Password', :with => 'password'
  fill_in 'Password confirmation', :with => 'drowssap'
  click_button 'Sign up'
end



