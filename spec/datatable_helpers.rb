module Datatable_helpers
  def load_datatable(params)
    param_str=''
    params.each { |k,v| param_str=param_str+"#{k}=#{v}&"}
    url="#{items_path}?#{param_str}"
    visit "#{url}"
    if /ajax/.match(params[:render_method])
      click_link("Create table")
    end
  end
  def sort_datatable(by)
    header_div=find(:xpath,"//div[contains(text(),'#{by[:column]}')]")
    header_div.click    #first click sorts ascending
    if (by[:order]==:descending)
      header_div.click  #second click sorts descending
    end
  end

end
