puts "DISPLAY EVENT TEST"
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

  describe ":display event" do

    it "should respond to the triggering of the :display event"

    it "should merge url parameter options into @options"

    it "should convert boolean values in @options to the appropriate defaults"

    it "should generate and render a json string from @options[:plugin]"

    it "should generate javascript to merge client-side plugin options when @options[:template][:plugin_options] != nil"

    it "should render display_html from the gem's path to a single-line, html_safe string when @options[:params][:format]=='js' and app/widgets/apotomo/datatable/display_html* is not present" #check for presence of "default apotomo-datatable view" in the string. Better test would be to find out which file is being used

    it "should render display_html from the app's path to a single-line, html_safe string when @options[:params][:format]=='js' and app/widgets/apotomo/datatable/display_html* is present" #check for non-presence of "default apotomo-datatable view" in the string. Better test would be to find out which file is being used

    it "should render display_js from the gem's path when @options[:params][:format]=='js' and app/widgets/apotomo/datatable/display_js* is not present"

    it "should render display_js from the app's path when @options[:params][:format]=='js' and app/widgets/apotomo/datatable/display_js* is present"

    it "should render display_html from the gem's path when @options[:params][:format]!='js' and app/widgets/apotomo/datatable/display_js* is not present"

    it "should render display_html from the app's path when @options[:params][:format]!='js' and app/widgets/apotomo/datatable/display_js* is present"

    describe "head_foot template" do

      it "should include the approprate elements as defined by @options[:template][:header]and @options[:template][:footer]"

    end
  end

end

