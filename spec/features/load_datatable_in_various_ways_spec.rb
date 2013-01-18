$run_in_browser=true

require 'spec_helper'
require 'datatable_helpers'

#This tests validity of the content by processing with javascript

describe 'Rendering an apotomo-datatable widget', :js=>true do
  include Datatable_helpers

  num_items=50
  before(:all) do
    (1..num_items).each {|n| FactoryGirl.create(:item)}
  end

  ['html','ajax_url_params','ajax_js_params'].each do |render_method|
    params={:render_method=>render_method}

    #TODO
    #set a non-default value to make sure url param option are processed correctly
    #this option will be hard coded for the ajax rendering options in the items index template
    #params['plugin[iDisplayStart]']=(render_method=='html') ? '20' : ''


    describe "with params #{params.inspect}" do
      it "should produce a jQuery Datatable" do
        load_datatable(params)
        page.should have_content("Showing 1 to 10 of #{num_items} entries")    
      end
    end
  end
end
