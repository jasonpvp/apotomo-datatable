require File.expand_path("../mock_items_controller", __FILE__)

#setup Apotomo::DatatableWidget instance for testing
#need to find a way to automate this
#find out how rspec-apotomo makes rspec aware of the widget directory
def rspecify(widget_class)
  widget_class.instance_eval do
    include RSpec::Rails::RailsExampleGroup
    include ActionController::TestCase::Behavior
    include RSpec::Rails::ViewRendering
    include RSpec::Rails::Matchers::RedirectTo
    include RSpec::Rails::Matchers::RenderTemplate
    include RSpec::Rails::Matchers::RoutingMatchers
  end
end

def test_controller(params)
  puts "LOAD mock_test_controller"
  load 'mock_items_controller.rb'
  puts "CALL has_widget_with_params"
  ItemsController.has_widget_with_params(params)
  puts "INSTANCIATE ItemsController"
  @controller=ItemsController.new
  @controller.request=::ActionController::TestRequest.new
  @controller.response=::ActionController::TestResponse.new
  @controller.params={}
  return @controller
end
