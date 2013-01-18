#https://gist.github.com/428105 capybara stuff
#https://gist.github.com/1190475  setup example

$run_in_browser=true

require 'spec_helper'

module Datatable_helpers
  def load_datatable(params)
    param_str=''
    params.each { |k,v| param_str=param_str+"#{k}=#{v}&"}
    url="#{items_path}?#{param_str}"
#    puts "visit #{url}"
    visit "#{url}"
    if /ajax/.match(params[:render_method])
      click_link("Create table")
    end
  end
  def sort_datatable(by)
#    puts "sort #{by[:column]} in #{by[:order].to_s} order"
    header_div=find(:xpath,"//div[contains(text(),'#{by[:column]}')]")
    header_div.click    #first click sorts ascending
    if (by[:order]==:descending)
      header_div.click  #second click sorts descending
    end
  end
end

describe 'Loading a datatable' do
  include Datatable_helpers

  items=[]
  num_items=50
  before(:all) do
    (1..num_items).each {|n| items[n]=FactoryGirl.create(:item)}
  end

  ['html','ajax_url_params','ajax_js_params'].each do |render_method|
    [''].each do |serverSideProcessing| #passing true or false to this param (as intended) will currently result in ugly failures. Need to fix server-side processing response
      params={:render_method=>render_method,'plugin[bServerSide]'=>serverSideProcessing}
      describe "with params #{params.inspect}", :js=>true do
        [:ascending,:descending].each do |sort_order|
          if sort_order==:ascending
            first_item,second_item='item1','item2'
          else
            first_item,second_item="item#{num_items}","item#{num_items-1}"
          end
          it "should be sortable in #{sort_order} order" do
            load_datatable(params)
            page.should have_content('Showing 1 to')    


            sort_datatable :column=>'value',:order=>sort_order
            page.should have_xpath("//td[contains(text(),'#{first_item}')]/following::td[contains(text(),'#{second_item}')]")
            save_page
          end
        end
      end
    end
#    save_and_open_page
  end
end
