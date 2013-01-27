puts "DATA EVENT TEST"
require 'spec_helper'
require 'widget_helper'

describe Apotomo::DatatableWidget, "apotomo-datatable widget" do
  rspecify(self)

  before :each do
    @test_controller=test_controller(:widget=>{},:template=>{},:plugin=>{})
    @widget=@test_controller.apotomo_root.childrenHash[:datatable]
    num_items=15
    (1..num_items).each {|n| FactoryGirl.create(:item)}
  end

  describe ":data event" do
    it "should render a json string with data when the :data event is triggered" do
      #This triggers the :data event, which queries the database returns a json string of the data
      @test_controller.render_widget(:datatable,:data).should include("\"iTotalRecords\":15")
    end
  end

end


