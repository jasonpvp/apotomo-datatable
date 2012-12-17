#include Rails.application.routes.url_helpers

=begin
  Apotomo-Datatables

  Dead simple to use, lots of configuration options

  Apotomo-Datatables may be rendered within a view (like a partial) or as javascipt for AJAX implementation

  Basic usage:

  The following exmaple demonstrates passing template and plugin options at each stage, 
  however the only required option below is template[parent] for the "Render via AJAX" example

  Gemfile
    gem 'apotomo-datatables'

  items_controller.rb
    root << items_datatable=widget('apotomo/datatable',:items_datatable,
      :widget=>{},   #widget options
      :template=>{:footer=>true}, #template options
      :plugin=>{:sScrollY=>150}    #plugin options
    )

    def index
      respond_to do |format|
        format.html
        format.js {render :script=>true}
      end
    end

    # If apotomo_datatable_datasource is defined, Apotomo::DatatableWidget.datasource will use this to populate its data collection
    # results returned from here are encapsulated in a hash expected by jquery datatables
    def apotomo_datatable_datasource(filter)
      Item.find(:all,filter)
    end

  index.html.haml
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

  index.js.haml
    =render_widget :items_datatable,:display,:widget=>{},:template=>{:footer=>true},:plugin=>{:sScrollY=>150}


  Options:

  The @options hash includes primary keys for the widget, templates and client-side plugin
    @options={:widget=>{...}, :template=>{...}, :plugin=>{...}}

  Default options are generated in Apotomo::DatatableWidget.set_options

  Default options may be overridden from the controller, view, by URL parameters and by a client-side javascript hash, as seen in the example above,  
  with the client-side javascript hash taking the highest precedence
    client_side_options -> url_param_options -> view_options -> controller_options -> default_options

  URL parameters may only define template and plugin options. Defining widget options from the URL would present a security hole
  The client-side hash may only define plugin options. Since it is not passed to the server, template and widget options would be irrelevant 

  $.extend(@options[:widget].to_json,client_side_options) constitutes the arguments passed to the datatable initialization function. 
  See http://datatables.net/usage/options for options.  As such, any option specified in the jquery datatables API may be set in this sub hash

=end

class Apotomo::DatatableWidget < Apotomo::Widget

  responds_to_event :data #Used by sAjaxSource plugin option
  responds_to_event :display

  after_initialize do
    ## set default options and those based on options provided in the has_widgets call in the controller
    set_options
  end

  def display(options)
    if options && options.respond_to?('each_pair')
      ## merge options provided by the render_widget method call in the view
      @options=@options.deep_merge(options)      
    end

    ## merge options from the URL params
    merge_param_options

    ## merge client-side plugin options
    datatable_options=@options[:plugin].to_json    
    if @options[:template][:plugin_options] 
      datatable_options="$.extend(#{datatable_options},#{@options[:template][:plugin_options]})"
    end

    @init_datatable_js= "$(\"##{@options[:template][:id]}\").dataTable(#{datatable_options});"

    if @options[:params][:format]=='js'
      @html=render_to_string :file => File.expand_path('../datatable/display_html', __FILE__)
      render :view=>:display_js
#      render (replace :view=>:display_html, :selector=>'div#parent')+@init_datatable_js
    else 
      render :view=>:display_html
    end
  end

  def datatable_init_vars
  end

  def data
    is_searching = (params[:sSearch] and params[:sSearch].length>0)
    @records=datasource
    @data={
      :iTotalRecords=>@model.count,
      :iTotalDisplayRecords=>is_searching ? @records.count : @model.count,
      :aaData=>@records
    }
    render text: @data.to_json
  end

  def datasource
    #datatable passes something like
    #"sEcho"=>"1", "iColumns"=>"5", "sColumns"=>"", "iDisplayStart"=>"0", "iDisplayLength"=>"10", "mDataProp_0"=>"id", "mDataProp_1"=>"text", "mDataProp_2"=>"created_at", "mDataProp_3"=>"updated_at", "mDataProp_4"=>"like", "sSearch"=>"", "bRegex"=>"false", "sSearch_0"=>"", "bRegex_0"=>"false", "bSearchable_0"=>"true", "sSearch_1"=>"", "bRegex_1"=>"false", "bSearchable_1"=>"true", "sSearch_2"=>"", "bRegex_2"=>"false", "bSearchable_2"=>"true", "sSearch_3"=>"", "bRegex_3"=>"false", "bSearchable_3"=>"true", "sSearch_4"=>"", "bRegex_4"=>"false", "bSearchable_4"=>"true", "iSortCol_0"=>"0", "sSortDir_0"=>"asc", "iSortingCols"=>"1", "bSortable_0"=>"true", "bSortable_1"=>"true", "bSortable_2"=>"true", "bSortable_3"=>"true", "bSortable_4"=>"true"
    # USE SCOPES /root/acts_as_flexigrid.rb
    filter={}
    is_searching = (params[:sSearch] and params[:sSearch].length>0)
    if is_searching
      filter[:conditions]=[@model.column_names.join(' LIKE :sSearch OR ')+' LIKE :sSearch',{:sSearch=>"%#{params[:sSearch]}%"}]
    end
    if params[:iDisplayStart] and params[:iDisplayLength]
      filter[:limit]=params[:iDisplayLength]
      filter[:offset]=params[:iDisplayStart]
    end
    if @controller.respond_to?('apotomo_datatable_datasource')
      @records=@controller.apotomo_datatable_datasource(filter)
    else
      @records=@model.find(:all,filter)
    end
    return @records
  end

  def create

  end

  def edit

  end

  def update

  end

  def destroy

  end

  def set_options

    @controller=parent_controller
    if match=/(\w+?)sController/.match(@controller.class.name.to_s)
      @controller_model_name=match[1]
    end

    if options[:widget][:model]
      if options[:widget][:model].respond_to?("columns_hash")
        @model=options[:widget][:model]
      end
    elsif @controller_model_name
      #derive the model from the controller name
      if defined?(@controller_model_name) && eval(@controller_model_name+'.respond_to?("columns_hash")')
        @model=eval(@controller_model_name)
      end
    end

    aoColumns=[]
    @model.column_names.each do |name|
      aoColumns.push({'mDataProp'=>name})
    end

    defaults={
      :widget=>{
      },
      :template=>{
        :footer=>false,
        :id=>"#{@model.name}Datatable"

      },
      :plugin=>{
        :bProcessing=>true,
        :bJQueryUI=>true
      }
    }.with_indifferent_access
    ## if options[:plugin][:sAjaxSource] is boolean or nil, derive default if true and delete option value from controller
    if !options[:plugin].has_key?(:sAjaxSource) || options[:plugin][:sAjaxSource]==true
      options[:plugin][:sAjaxSource]=url_for_event(:data)
      defaults[:plugin][:bServerSide]=true # User server-side processing: http://datatables.net/ref#bServerSide
    elsif !options[:plugin][:sAjaxSource]
      options[:plugin].delete(:sAjaxSource) #delete false or nil value to prevent invalid option from passing to plugin
    end
    ## profide column mapping if using ajax or aaData
    ## provide aaData if requested
    if options[:plugin][:sAjaxSource] || options[:plugin][:aaData]==true
      defaults[:plugin][:aoColumns]=aoColumns
      if options[:plugin][:aaData]==true
        records=datasource
        options[:plugin][:aaData]=records
      end
    end
    # merge default options with options provided by the controller
    @options=defaults.deep_merge(options)
    @options[:params]=params
  end

  def merge_param_options
    #this is insecure since it would allow the client to set options for the 
    #if params[:widget] && params[:widget].respond_to?('each_pair') 
    #  @options[:widget]=@options[:widget].deep_merge(params[:widget])
    #end
    if params[:template] && params[:template].respond_to?('each_pair')
      @options[:template]=@options[:template].deep_merge(params[:template])
    end
    if params[:plugin] && params[:plugin].respond_to?('each_pair')
      @options[:plugin]=@options[:plugin].deep_merge(params[:plugin])
    end
  end
end
