puts "DATA EVENT TEST"
require 'spec_helper'
require 'widget_helper'

describe Apotomo::DatatableWidget, "apotomo-datatable widget" do
  rspecify(self)

  before :all do
    @controller=test_controller(:widget=>{},:template=>{},:plugin=>{})
    @widget=@controller.apotomo_root.childrenHash[:datatable]
    puts "UID=#{@widget.uid}"
  end

  before :each do
    num_items=15
    (1..num_items).each {|n| FactoryGirl.create(:item)}
  end

  describe ":data event" do
    it "should respond to the triggering of the :data event"

    it "should render data when the :data event is triggered" do
      #This triggers the :data event, which queries the database returns a json string of the data
      @controller.render_widget(:datatable,:data).should include("\"iTotalRecords\":15")
    end
  end

end


