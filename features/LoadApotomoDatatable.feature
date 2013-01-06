Feature: Load Apotomo-Datatable widget
  In order to make UI development as easy as possible
  As a dev
  I want to be able to generate a jQuery Datatable for a model with zero configuration

  @javascript
  Scenario: Load an Apotomo-Datatable with server-side processing
    Given I am on the items page
    Then I should see "name" before "value"
    And I should see "Showing 1 to 10 of 100 entries"

#  @javascript
#  Scenario: Load an Apotomo-Datatable via AJAX by clicking a link
#    When I visit the items page
#    And I click on link "Create from AJAX with URL params"
#    Then I should see "Showing 1 to 100" after "Showing 1 to 100"
