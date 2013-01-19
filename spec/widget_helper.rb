class ItemsController < ApplicationController
  extend Apotomo::Rails::ControllerMethods

  #call MockModelsController.has_widget_with_params(:widget=>{...},:template=>{...},:plugin=>{...}) prior to MockModelsController.new
  def self.has_widget_with_params(params={})
    self.has_widgets do |root|
      root << items_datatable=widget('apotomo/datatable',:datatable,params)
    end
  end
end
=begin
class MockModel < ActiveRecord::Base
  attr_accessible :name, :value
  def self.column_names
    {:name=>nil, :value=>nil}
  end
end
=end

