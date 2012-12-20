#include Rails.application.routes.url_helpers

=begin
  Apotomo-Datatables

  Basic usage with default options:

  Gemfile
    gem 'apotomo-datatables'

  items_controller.rb
    root << items_datatable=widget('apotomo/datatable',:items_datatable)

  index.html.haml
    #render as HTML like a partial
    =render_widget :items_datatable,:display

    #render via AJAX
    %div#parentDiv
      =link_to "Create table from options set in the URL", items_path+'.js?template[parent]=parentDiv, :remote=>true

  index.js.haml #used to render via AJAX
    =render_widget :items_datatable,:display

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

    #make sure :header and :footer are arrayc
    if @options[:template][:header] && ! @options[:template][:header].respond_to?('each') then @options[:template][:header]=[@options[:template][:header]] end
    if @options[:template][:footer] && ! @options[:template][:foote].respond_to?('each') then @options[:template][:footer]=[@options[:template][:footer]] end


    @init_datatable_js= "$(\"##{@options[:template][:id]}\").dataTable(#{datatable_options});"

    if @options[:params][:format]=='js'
      #TODO: escape double quotes and new lines
      @html=render_to_string :file => File.expand_path('../datatable/display_html', __FILE__)
      render :view=>:display_js
#      render (replace :view=>:display_html, :selector=>'div#parent')+@init_datatable_js
    else 
      render :view=>:display_html
    end
  end

  def datatable_init_vars
  end

  def head_foot(section)
    render :locals=>{:section=>section}
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
=begin
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
        #The header and footer have the same options for parameters. Each may be a single value, an array or a hash
        #If a single value or array, all columns are rendered with the provided options in order
        #If a hash, each key should match column field names. Each key-value is a value or array as above
        #single value or array options are: nil: ommited, label: label, input: input column filter, select: select column filter
        :header=>[:label,:input], 
        :footer=>nil, 
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
