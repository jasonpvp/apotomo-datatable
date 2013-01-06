#http://eggsonbread.com/2010/09/06/my-cucumber-best-practices-and-tips/

#This has been replaced by a much more flexible test in spec/features
Feature: Sort Apotomo-Datatable
  In order to test sorting
  As a dev
  I should be able to see this test pass

  @javascript
  Scenario Outline:
    Given I am on a page with a datatable
    When I sort the table by <column> in <sort> order
    Then I should see "<the_top_item>" before "<the_next_item>"

    Examples:
      | column    | sort         | the_top_item  | the_next_item |
      | value     | ascending    | item1         | item2         |
      | value     | descending   | item100       | item99        |


