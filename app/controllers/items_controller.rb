class ItemsController < ApplicationController
  has_widgets do |root|
    root << items_datatable=widget('apotomo/datatable',:items_datatable,
      :widget=>{},
      :template=>{},
      :plugin=>{}
    )
  end

  def index
    respond_to do |format|
      format.html
      format.js {render :script=>true}
    end
  end

  def apotomo_datatable_datasource(filter)
    Item.find(:all,filter)
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
