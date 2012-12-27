module LoadApotomoDatatable
end

World(LoadApotomoDatatable)

When /^I visit (the [^"]+ page)$/ do |page_name|
  visit path_to(page_name)
end

Then /^I should see "([^"]+)"$/ do |text|
  assert page.body =~ /#{text}/m
end

Then /^I should see "([^"]+)" (before|after) "([^"]+)"$/ do |text1,order,text2|
  if order=='after' then text1,text2=text2,text1 end
  assert page.body =~ /#{text1}.*#{text2}/m
end

When /^I click on link "([^"]+)"$/ do |link_text|
  click_link link_text
  sleep 2
end

When /^I click on a div with class "([^"]+)" containing the text "([^"]+)"$/ do |class_name,text|
  find(:xpath,"//div[contains(@class,'#{class_name}') and contains(text(),'#{text}')]").click
  sleep 2
end
