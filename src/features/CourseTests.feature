Feature: Course Abilities
  In order to interact with courses
  As an admin or faculty
  I want to create, view and destroy courses

Scenario: Visit course index
  Given I am logged in as an admin
  When I visit the course index page
  Then I should see "Add Course"

Scenario: Course Createion Fails with No File
  Given I am logged in as an admin
  When I visit the course index page
  And I click add course
  
  

