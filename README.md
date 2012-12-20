# Apotomo-Datatable
  (Soon to be) a Rails Gem for using of jQuery Datatables with extremely minimal configuration

  Built on the Apotomo widget gem

  Apotomo-Datatables may be rendered within a view (like a partial) or as javascipt for AJAX implementation

## Usage

  The following exmaple demonstrates creating a datatable as a rendered widget (apotomo cell partial)
  from within a view, and using AJAX with two different methods for passing plugin options.

### Gemfile
    gem 'apotomo-datatables'
    gem 'haml'

### items_controller.rb
    root << items_datatable=widget('apotomo/datatable',:items_datatable,
      :widget=>{},   #widget options (the model is derived from the controller name by default, but may be passed here as :model=>Model)
      :template=>{:footer=>true}, #template options
      :plugin=>{:sScrollY=>150}    #plugin options
    )

    def index
      respond_to do |format|
        format.html
        format.js {render :script=>true}
      end
    end

    # By defaultathe widget will query the model on its own
    # If apotomo_datatable_datasource is defined, Apotomo::DatatableWidget.datasource will use this to populate
    # its data collection results returned from here are encapsulated in a hash expected by jquery datatables
    def apotomo_datatable_datasource(filter)
      Item.find(:all,filter)
    end

### index.html.haml
    %h1="Apotomo Datatable Example"

    %h2="Rendered as HTML"
    =render_widget :items_datatable,:display,:plugin=>{:sScrollY=>100,:bScrollCollapse=>true},:template=>{:id=>'html_datatable'}

    %h2="Rendered via AJAX"

    %div#parentDiv1
      =link_to "Create table from options set in the URL", items_path+'.js?template[parent]=parentDiv1&plugin[sScrollY]=100', :remote=>true

    :javascript
      var plugin_options={sScrollY: 50, iDisplayStart: 20};


    %div#parentDiv2
      =link_to "Create table from options defined in javascript variable", items_path+'.js?template[plugin_options]=plugin_options&template[parent]=parentDiv2&template[id]=datatable_2', :remote=>true

### index.js.haml
    =render_widget :items_datatable,:display,:widget=>{},:template=>{:footer=>true},:plugin=>{:sScrollY=>150}


## Options

  The @options hash includes sub-hashes for the widget, templates and client-side plugin
    @options={:widget=>{...}, :template=>{...}, :plugin=>{...}}

  Default options are generated and merged with controller-provided options in Apotomo::DatatableWidget.set_options

  Default options may be overridden from the controller, view, by URL parameters and by a client-side javascript hash, as seen in the example above, with the client-side javascript hash taking the highest precedence
    client_side_options -> url_param_options -> view_options -> controller_options -> default_options

  URL parameters may only define template and plugin options. Defining widget options from the URL would present a security hole

  The client-side hash may only define plugin options. Since this hash is not passed to the server template and widget options would never be seen

  $.extend(@options[:widget].to_json,client_side_options) constitutes the arguments passed to the datatable initialization function. 
  See http://datatables.net/usage/options for options.  As such, any option specified in the jquery datatables API may be set in this sub hash

