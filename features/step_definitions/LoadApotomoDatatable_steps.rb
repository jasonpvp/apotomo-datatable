module LoadApotomoDatatable
end

World(LoadApotomoDatatable)

Given /^I visit (the [^"]+ page)$/ do |page_name|
  visit path_to(page_name)
end

Then /^I should see "([^"]+)"$/ do |text|
  assert page.body =~ /#{text}/m
end

Then /^I should see "([^"]+)" before "([^"]+)"$/ do |text1,text2|
  assert page.body =~ /#{text2}.*#{text2}/m
end

