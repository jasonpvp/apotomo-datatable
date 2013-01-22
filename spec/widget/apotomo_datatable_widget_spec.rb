puts "APOTOMO DATATABLE TEST"
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

  it "should be an instance of Apotomo::DatatableWidget" do
    @widget.should be_an_instance_of(Apotomo::DatatableWidget)
  end

  it "should respond to method calls" do
    lambda{@widget.increment_test_val}.should change(@widget,:test_val).by(1)
  end

  describe "after_initialize" do
    it "should merge default options with options passed by the controller into @options"
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
