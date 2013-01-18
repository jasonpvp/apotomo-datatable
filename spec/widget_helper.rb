class MockModelsController < ActionController::Base
  extend Apotomo::Rails::ControllerMethods
end

class MockModel < ActiveRecord::Base
  attr_accessible :mock_field
  def self.column_names
    {:mock_field=>nil}
  end
end

MockModelsController.has_widgets do |root|
  root << items_datatable=widget('apotomo/datatable',:datatable,
    :widget=>{},
    :template=>{},
    :plugin=>{:sAjaxSource=>nil}
  )
end
