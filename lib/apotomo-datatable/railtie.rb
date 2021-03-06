require "rails/railtie"

module ApotomoDatatable
  class Railtie < ::Rails::Railtie
#    rake_tasks do
#      load "apotomo/apotomo.rake"
#    end

    # As we are a Railtie only, the routes won't be loaded automatically. Beside that, we want our 
    # route to be the very first (otherwise #resources might supersede it).
#    initializer 'apotomo.prepend_routes', :after => :add_routing_paths do |app|
#      app.routes_reloader.paths.unshift(File.dirname(__FILE__) + "/../../config/routes.rb")
#    end

    # Include a lazy loader via has_widgets.
#    initializer 'apotomo.add_has_widgets' do |app|
#      ActionController::Base.extend Apotomo::Rails::ControllerMethodsLoader
#    end

    initializer 'apotomo-datatable.setup_view_paths', :after => 'apotomo.setup_view_paths' do |app|
      Apotomo::DatatableWidget.setup_view_paths!
    end
  end
end
