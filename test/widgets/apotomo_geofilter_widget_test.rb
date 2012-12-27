require 'test_helper'

class ApotomoGeofilterWidgetTest < Apotomo::TestCase
  has_widgets do |root|
    root << widget(:apotomo_geofilter)
  end
  
  test "display" do
    render_widget :apotomo_geofilter
    assert_select "h1"
  end
end
