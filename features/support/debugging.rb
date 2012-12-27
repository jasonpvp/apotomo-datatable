After do |scenario|
  if ENV['DEBUG']
     save_and_open_page if scenario.failed?
  end
end
