require 'spec_helper'
require 'widget_helper'

describe Apotomo::DatatableWidget, "apotomo-datatable widget" do
    include RSpec::Rails::RailsExampleGroup
    include ActionController::TestCase::Behavior
    include RSpec::Rails::ViewRendering
    include RSpec::Rails::Matchers::RedirectTo
    include RSpec::Rails::Matchers::RenderTemplate
    include RSpec::Rails::Matchers::RoutingMatchers

  before :all do
    ItemsController.has_widget_with_params(:widget=>{},:template=>{},:plugin=>{})
    @controller=ItemsController.new
    @controller.request=::ActionController::TestRequest.new
    @controller.response=::ActionController::TestResponse.new
    @controller.params={}
    num_items=50
    (1..num_items).each {|n| FactoryGirl.create(:item)}
  end

  before :each do
    #the next line runs @widget.set_options, so it should probably be in a test
    @widget=@controller.apotomo_root.childrenHash[:datatable]
  end

  it "should be an instance of Apotomo::DatatableWidget" do
    @widget.should be_an_instance_of(Apotomo::DatatableWidget)
  end

  it "should increment test_val" do
    lambda{@widget.increment_test_val}.should change(@widget,:test_val).by(1)
  end

  it "should render data when the :data event is triggered" do
    @controller.render_widget(:datatable,:data).should include("iTotalRecords")
  end
end

def msg(o,m)
# for brute-force debugging
#    @controller.response.methods.sort.each do |m|
#      puts "#{m}=#{msg(@controller.response, m)}"
#    end

  begin
    o.send m
  rescue
    ""
  end
end
