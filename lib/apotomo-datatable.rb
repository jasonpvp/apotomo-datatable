require 'apotomo/datatable_widget'
require 'apotomo-datatable/railtie'
module ApotomoDatatable
  class Engine < Rails::Engine
#    loads views from 'cell/views' and NOT from 'app/cells'
#    config.paths.add 'app/cell_views', :with => 'cell/views'
  
#    appends 'lib/my_cells_view_path' to this Railtie view path contribution
#    config.paths['app/cell_views'] << 'lib/apotomo/datatable'
  end
end
