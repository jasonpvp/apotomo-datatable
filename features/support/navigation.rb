module NavigationHelpers
 def path_to(page_name)
   case page_name
   when /home page/
    root_path
   else
    begin
     page_name =~ /the (.*) page/
     path_components = $1.split(/\s+/)
     self.send(path_components.push('path').join('_').to_sym)
    rescue Object => e
     raise "can't find mapping from \"#{page_name}\" to a path. \n" + "Now, go and add a mapping in #{__FILE__}" 
    end
   end
 end
end

World(NavigationHelpers)

When /^I visit (the [^"]+ page)(\s+with\s+)?(.*)$/ do |page_name,with_params,params|
  if with_params
    params=params.split(/\s*and\s*/).join('&')
  end
  url=path_to(page_name)+'?'+params
  puts "visiting #{url}"
  visit url
end

Then /^I should see "([^"]+)"(\s+(before|after) "([^"]+)")?$/ do |text1,more,order,text2|
  if order=='after' then text1,text2=text2,text1 end
  assert page.body =~ /#{text1}.*#{text2}/m
end

When /^I click on the link "([^"]+)"$/ do |link_text|
  click_link link_text
  sleep 2
end

When /^I click on a div with class "([^"]+)" containing the text "([^"]+)"$/ do |class_name,text|
  find(:xpath,"//div[contains(@class,'#{class_name}') and contains(text(),'#{text}')]").click
  sleep 2
end
