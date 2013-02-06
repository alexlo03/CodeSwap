

When /^I visit the course index page$/ do
  visit 'courses/'
end

And /^I click add course$/ do
  find("#add_course").click
end

And /^I fill out new course info$/ do
  fill_in "course_number", :with => "Test101"
  fill_in "course_section", :with => "1"
  fill_in "course_name", :with => "Hope this works"
  fill_in "course_term", :with => "Winter 12-13"
end

