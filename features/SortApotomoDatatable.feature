Feature: Sort Apotomo-Datatable
  In order to test sorting
  As a dev
  I should be able to see this test pass

  @javascript
  Scenario: Sort datatable without server-side processing
    When I visit the items page
    Then I should see "Showing 1 to 10 of 100 entries"
    When I click on a div with class "DataTables_sort_wrapper" containing the text "value"
    Then I should see "item1" before "item2"
    When I click on a div with class "DataTables_sort_wrapper" containing the text "value"
    Then I should see "item100" before "item99"

  @javascript
  Scenario: Sort datatable with server-side processing
    When I visit the items page
    Then I should see "Showing 1 to 10 of 100 entries"
    When I click on a div with class "DataTables_sort_wrapper" containing the text "value"
    Then I should see "item1" before "item2"
    When I click on a div with class "DataTables_sort_wrapper" containing the text "value"
    Then I should see "item100" before "item99"

