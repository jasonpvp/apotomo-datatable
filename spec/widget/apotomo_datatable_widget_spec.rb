puts "APOTOMO DATATABLE TEST"
require 'spec_helper'
require 'widget_helper'

@test_controller_options={}

describe Apotomo::DatatableWidget, "apotomo-datatable widget" do
  rspecify(self)

  before :each do
    # The test_controller is not created here since we're testing sending different params to that method
    num_items=15
    (1..num_items).each {|n| FactoryGirl.create(:item)}
  end

  it "should be an instance of Apotomo::DatatableWidget" do
    @test_controller=test_controller(:widget=>{:name=>'test_datatable_widget'},:template=>{:id=>'test_datatable'},:plugin=>{:iDisplayStart=>10})
    @widget=@test_controller.apotomo_root.childrenHash[:datatable]
    @widget.should be_an_instance_of(Apotomo::DatatableWidget)
  end

  describe "after_initialize without controller_options provided" do
    before :each do
      @test_controller=test_controller()
      @widget=@test_controller.apotomo_root.childrenHash[:datatable]
    end

    it "should merge default options with options passed by the controller into @options" do
      options=@widget.merged_options
      options[:widget][:name].should == 'ItemDatatableWidget'
      options[:template][:id].should == 'ItemDatatable'
      options[:plugin][:iDisplayStart].should == 0
    end
  end

  describe "after_initialize with controller_options provided" do
    before :each do
      @test_controller=test_controller(:widget=>{:name=>'test_datatable_widget'},:template=>{:id=>'test_datatable'},:plugin=>{:iDisplayStart=>10})
      @widget=@test_controller.apotomo_root.childrenHash[:datatable]
    end

    it "should merge default options with options passed by the controller into @options" do
      options=@widget.merged_options
      options[:widget][:name].should == 'test_datatable_widget'
      options[:template][:id].should == 'test_datatable'
      options[:plugin][:iDisplayStart].should == 10
    end
  end

  it "should respond to method calls" do
    @test_controller=test_controller(:widget=>{:name=>'test_datatable_widget'},:template=>{:id=>'test_datatable'},:plugin=>{:iDisplayStart=>10})
    @widget=@test_controller.apotomo_root.childrenHash[:datatable]

    lambda{@widget.increment_test_val}.should change(@widget,:test_val).by(1)
  end

  it "should raise an exception without a model to use" do
    class OrphanController < MockController
    end
    OrphanController.has_widget_with_params()
    @test_controller=OrphanController.new
    @test_controller.request=::ActionController::TestRequest.new
    @test_controller.response=::ActionController::TestResponse.new
    @test_controller.params={}
    lambda {@widget=@test_controller.apotomo_root.childrenHash[:datatable]}.should raise_error
  end

  it "should raise an exception when provided an invalid model from the controller options" do
    class OrphanController < MockController
    end
    OrphanController.has_widget_with_params(:widget=>{:model=>nil})
    @test_controller=OrphanController.new
    @test_controller.request=::ActionController::TestRequest.new
    @test_controller.response=::ActionController::TestResponse.new
    @test_controller.params={}
    lambda {@widget=@test_controller.apotomo_root.childrenHash[:datatable]}.should raise_error
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
