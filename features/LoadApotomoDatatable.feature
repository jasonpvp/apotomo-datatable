#http://www.sarahmei.com/blog/2010/05/29/outside-in-bdd/
Feature: Load Apotomo-Datatable widget
  In order to make UI development as easy as possible
  As a dev
  I want to be able to generate a jQuery Datatable for a model with zero configuration

  @javascript
  Scenario: Load an Apotomo-Datatable with server-side processing
    Given I visit the items page
    Then I should see "name" before "value"
    Then I should see "Showing 1 to 10 of 100 entries"

