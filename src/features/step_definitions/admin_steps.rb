
When /^I go to the admin page$/ do
  visit 'admin/'
end

Given /^I am logged in as an admin$/ do
  visit '/'
  User.create(:email => 'admin@admin.com', :password => 'admins_are_the_best', :role => 'admin')
  visit 'users/sign_in'
  fill_in "Email", :with => 'admin@admin.com'
  fill_in 'Password', :with => 'admins_are_the_best'
  click_button 'Sign in'
end

Given /^There is a faculty member$/ do
  User.create(:email => 'faculty@faculty.com', :password => 'admins_are_the_best', :role => 'faculty')
end

When /^Enter a new faculty member email$/ do
  fill_in "faculty_email", :with => 'newguy@faculty.com'
end


When /^I click Add$/ do
  find("#submit_faculty").click
  find_field("faculty_email").value.should == ""
  visit current_path
end
