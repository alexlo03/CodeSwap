Feature: Log-In
  In order to log-in
  As a student 
  I want to create a account and log in

Scenario: Log in
  Given I am not logged in
  And I have an account
  When I go to the sign in page
  And I sign in
  Then I should see "Signed in successfully"
  
Scenario: Log out
  Given I am not logged in
  And I have an account
  When I go to the sign in page
  And I sign in
  And I log out
  Then I should see "Signed out successfully"

Scenario: Fail sign in
  Given I am not logged in
  And I have an account
  When I go to the sign in page
  And I sign in incorrectly
  Then I should see "Sign in"
  

