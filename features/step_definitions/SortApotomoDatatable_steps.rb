When /^I sort the table by (.*) in (.*) order$/ do |column,order|
  step %{I click on a div with class "DataTables_sort_wrapper" containing the text "#{column}"}
  if order=='descending' #descending order is accomplished by clicking the column header twice
    step %{I click on a div with class "DataTables_sort_wrapper" containing the text "#{column}"}
  end
end
