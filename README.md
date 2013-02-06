# Apotomo-Datatable
  Rails Gem for generating jQuery Datatables with extremely minimal configuration

  Built on the Apotomo widget gem

  Pacaged with jQuery Datatables version 1.9.4

  Datatables may be rendered within a view (like a partial) or as javascipt for AJAX implementation

## Usage

### Gemfile
    gem 'apotomo-datatable'
    gem 'haml'

### Simple use case for a given model/controller

#### items_controller.rb
  has_widgets do |root|
    root << datatable=widget('apotomo/datatable',:datatable)
  end

#### Embedding with an HTML view
##### view/items/index.html.haml
  =render_widget :datatable,:display

#### AJAX rendering
##### view/items/index.html.haml
  %div#parentDiv
    =link_to "Create table", items_path+'.js?template[parent]=parentDiv', :remote=>true, :title=>"Create table"
##### view/items/index.js.haml
  =render_widget :datatable,:display

### Passing options from various points

#### items_controller.rb
    root << datatable=widget('apotomo/datatable',:datatable,
      :widget=>{},   #widget options (the model is derived from the controller name by default, but may be passed here as :model=>Model)
      :template=>{:footer=>true}, #template options
      :plugin=>{:sScrollY=>150}    #plugin options, see: http://datatables.net/usage/options
    )

    def index
      respond_to do |format|
        format.html
        format.js {render :script=>true}
      end
    end

    # By defaultathe widget will query the model on its own
    # If apotomo_datatable_datasource is defined, Apotomo::DatatableWidget.datasource will use this to populate
    # The hash provided, which is expected to be standard search results from an ActiveRecord query, is encapsulated in a hash expected by jquery datatables

    def apotomo_datatable_datasource(filter)
      Item.find(:all,filter)
    end

#### view/items/index.html.haml
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

#### index.js.haml
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
  Note: Server-side processing is not yet supported

  By default, :id, :created_at and :updated_at columns are excluded from display. 
  Pass the [:template][:excluded_columns] option to exclude more
  Pass the [:template][:included_columns] option to include excluded columns

## Current Status

  The above examples will load a functional datatable, with sorting and global filtering working
  Basic tests for loading and sorting are implemented.  Sorting tests fail when plugin[bServerSide]=true since that is not implemented yet
  Template for column-based filters started, but not yet complete or functional

## TODO

  Implement server-side sorting and filtering
  Expand feature tests
  Implementing the other base features
  Move on to implementing plugins
