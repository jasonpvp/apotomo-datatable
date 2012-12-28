#http://eggsonbread.com/2010/09/06/my-cucumber-best-practices-and-tips/
Feature: Sort Apotomo-Datatable
  In order to test sorting
  As a dev
  I should be able to see this test pass

  @javascript
  Scenario Outline: Sort datatable with various render and sAjaxSource options
    When I visit the items page with render_method=<render_method> and plugin[sAjaxSource]=<sAjaxSource>
    And I click on the link "Create table"
    Then I should see "Showing 1 to 10 of 100 entries"
    When I click on a div with class "DataTables_sort_wrapper" containing the text "value"
    Then I should see "item1" before "item2"
    When I click on a div with class "DataTables_sort_wrapper" containing the text "value"
    Then I should see "item100" before "item99"

    Examples:
      | render_method   | sAjaxSource |
      |                 |             |
      | html            | false       |
      | html            | true        |
      | ajax_url_params | false       |
      | ajax_url_params | true        |
      | ajax_js_params  | false       |
      | ajax_js_params  | true        |


