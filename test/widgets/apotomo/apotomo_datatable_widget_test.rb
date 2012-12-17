require 'test_helper'

class Apotomo::DatatableWidgetTest < Apotomo::TestCase
  has_widgets do |root|
    root << widget(:apotomo_datatable)
  end
  
  test "display" do
    render_widget :apotomo_datatable
    assert_select "h1"
  end
end
