class MockModelsController < ActionController::Base
  extend Apotomo::Rails::ControllerMethods

  #call MockModelsController.has_widget_with_params(:widget=>{...},:template=>{...},:plugin=>{...}) prior to MockModelsController.new
  def self.has_widget_with_params(params={})
    self.has_widgets do |root|
      root << items_datatable=widget('apotomo/datatable',:datatable,params)
    end
  end
end

class MockModel < ActiveRecord::Base
  attr_accessible :mock_field
  def self.column_names
    {:mock_field=>nil}
  end
end


