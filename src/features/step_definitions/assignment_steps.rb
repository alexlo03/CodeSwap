Given /^I have a course$/ do
  Course.create(:course_number => '1199911', :name => 'Test Course For Sure', :section => '01', :term => 'Fall', :user_id => User.find_by_email('admin@admin.com').id)
end

Given /^I am on the course page for "Test Course For Sure"$/ do
  visit '/course/show/' + Course.find_by_course_number('1199911').id.to_s
end

When /^I enter assignment information for "Test Course Assignment"$/ do
  fill_in 'name', :with => 'Test Course Assignment'
  fill_in 'description', :with => 'Testing this Course!'
end

When /^I click "Create New"$/ do
  click_button 'Create New'
end

When /^I click "Submit"$/ do 
  click_button 'Submit'
end