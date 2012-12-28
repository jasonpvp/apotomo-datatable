class ItemsController < ApplicationController
  has_widgets do |root|
    root << items_datatable=widget('apotomo/datatable',:items_datatable,
      :widget=>{},
      :template=>{},
      :plugin=>{:sAjaxSource=>nil}
    )
    @root=root
  end

  def index
    @render_method = params[:render_method] ? params[:render_method].downcase : 'html'
    if !['html','ajax_url_params','ajax_url_params'].include?(@render_method)
      @render_method='html'
    end
    respond_to do |format|
      format.html
      format.js {render :script=>true}
    end
  end

  def apotomo_datatable_datasource(filter)
    Item.find(:all,filter)
  end

  def apotomo_datatable_event(event)
    "controller responded to event from #{event.source} which has parent #{event.source.parent}"
    ""
  end

  def show
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
