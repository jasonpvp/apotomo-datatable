=begin
This is a kind of ugly hack to get rspec testing working cleanly
Apotomo adds a widget tree to a controller class. This means the widget instances are children of a class property
In order to reliably ensure that there are no inter-test dependencies, the below code deletes the controller used in tests and redefines it
whenever the test_controller method is called in widget_helper.  That method calls has_widget_with_params to freshly instanciate the widget tree
with whatever params are passed to it
=end

=begin
It's also probably not good that we're depending on ItemsController from the dummy app
The final test setup will define
  TestTemplateController
  MockItemsController < TestTemplateController
  MockItem model  (apotomo-datatable looks for a model with a name that corresponds to the controller name)

Where MockModelsController is defined entirely here

But this works for the moment
=end
if !Object.const_defined?(:MockController) or !MockController.respond_to?(:has_widget_with_params) then
  class MockController < ApplicationController
    extend Apotomo::Rails::ControllerMethods

    def self.has_widget_with_params(params={})
      puts "MAKE WIDGET using #{params.inspect}"
      self.has_widgets do |root|
        root << items_datatable=widget('apotomo/datatable',:datatable,params)
      end
    end
  end
end

if Object.const_defined?(:ItemsController) then
  if ItemsController.is_a?(Class) then
    puts "DELETE ItemsController"
    Object.send(:remove_const,:ItemsController)
    puts "ItemsController deleted"
  end
end

class ItemsController < MockController
  
end
