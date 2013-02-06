Feature: Admin abilities
  In order to set up the system
  As an admin
  I want to create and manage faculty 

Scenario: Visit admin page
  Given I am logged in as an admin
  When I go to the admin page
  Then I should see "Administrators"

Scenario: Faculty appears
  Given I am logged in as an admin
  And There is a faculty member
  When I go to the admin page
  Then I should see "faculty@faculty.com"




  
