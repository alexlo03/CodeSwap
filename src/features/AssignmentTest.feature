
Feature: Create New
In order to create an assignment
As an admin
I want to have assignments

Scenario: Click Create
Given I am logged in as an admin
  And I have a course
  And I am on the course page for "Test Course For Sure"
  When I click "Create New"
  Then I should see "Creating assignment for Test Course For Sure"
  
Scenario: Fill Form
Given I am logged in as an admin
  And I have a course
  And I am on the course page for "Test Course For Sure"
  When I click "Create New"
  And I enter assignment information for "Test Course Assignment"
  And I click "Submit"
  Then I should see "Test Course Assignment"
  

