puts "MERGE OPTIONS TESTS"
require 'spec_helper'
require 'widget_helper'

describe Apotomo::DatatableWidget, "apotomo-datatable widget" do
  rspecify(self)

  before :each do
    @test_controller=test_controller(:widget=>{},:template=>{},:plugin=>{})
    @widget=@test_controller.apotomo_root.childrenHash[:datatable]
  end

  describe "display method" do
    it "should merge view_options into @merged_options if provided" do
      @widget.display(:widget=>{:test_option=>'view'},:template=>{:test_option=>'view'},:plugin=>{:test_option=>'view'})
      merged_options=@widget.merged_options
      merged_options[:widget][:test_option].should == 'view'
      merged_options[:template][:test_option].should == 'view'
      merged_options[:plugin][:test_option].should == 'view'
    end

    it "should merge url_param_options into @merged_options" do
      @test_controller.params={:widget=>{:test_option=>'url'},:template=>{:test_option=>'url'},:plugin=>{:test_option=>'url'}}.with_indifferent_access
      @widget.display(:widget=>{:test_option=>'view'},:template=>{:test_option=>'view'},:plugin=>{:test_option=>'view'})
      merged_options=@widget.merged_options
      #widget options should not be overridden by URL params
      merged_options[:widget][:test_option].should == 'view'
      #template and plugin options should be overridden by url params
      merged_options[:template][:test_option].should == 'url'
      merged_options[:plugin][:test_option].should == 'url'
    end
  end
end


