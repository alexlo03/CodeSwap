Feature: Log-In
  In order to log-in
  As a student 
  I want to create a account and log in

Scenario: Create new student account
  Given I am not logged in
  When I go to the sign up page
  And enter "Student" information
  Then I should see "signed up successfully"

Scenario: Create new admin account
  Given I am not logged in
  When I go to the sign up page
  And enter "Admin" information
  Then I should see "signed up successfully"
  And I should see "You are logged in as an administrator!"

Scenario: Create new faculty account
  Given I am not logged in
  When I go to the sign up page
  And enter "Faculty" information
  Then I should see "signed up successfully"
  And I should see "You are logged in as faculty!"

Scenario: Create new TA account
  Given I am not logged in
  When I go to the sign up page
  And enter "Ta" information
  Then I should see "signed up successfully"
  And I should see "You're logged in as a TA!!!!!!!!!!!!!!!!"

Scenario: Fail to create account
  Given I am not logged in
  When I go to the sign up page
  And enter bad passwords
  Then I should see "error"
  And I should see "Password doesn't match confirmation"

Scenario: Log out
  Given I am not logged in
  When I go to the sign up page
  And enter "Ta" information
  And I log out
  Then I should see "Signed out successfully"

