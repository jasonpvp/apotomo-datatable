require 'spec_helper'
require 'widget_helper'

describe Apotomo::DatatableWidget, "apotomo-datatable widget" do

  before :each do
    @controller=MockModelsController.new
    @controller.request=::ActionController::TestRequest.new
    @controller.response=::ActionController::TestResponse.new
    @controller.params={}
    #the next line runs @widget.set_options, so it should probably be in a test
    @widget=@controller.apotomo_root.childrenHash[:datatable]
  end

  it "should be an instance of Apotomo::DatatableWidget" do
    @widget.should be_an_instance_of(Apotomo::DatatableWidget)
  end

  it "should increment test_val" do
    lambda{@widget.increment_test_val}.should change(@widget,:test_val).by(1)
  end
end
