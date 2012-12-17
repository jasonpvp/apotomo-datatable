class ItemsController < ApplicationController
  has_widgets do |root|
    root << items_datatable=widget('apotomo/datatable',:items_datatable,
      :widget=>{:model=>Item},
      :template=>{},
      :plugin=>{}
    )
  end

  def index
    item=Item.new
    val=(rand()*100).to_i
    item.update_attributes({:name=>"item#{val}",:value=>val,:when=>Time.now})
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
