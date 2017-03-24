Feature: Testing

  Scenario: Home Page
    Given I am on the homepage
    Then I should see "Laravel"
    Then print last response
    Then print current URL