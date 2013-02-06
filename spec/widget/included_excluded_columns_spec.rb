puts "INCLUDED/EXCLUDED COLUMNS TEST"
require 'spec_helper'
require 'widget_helper'

describe Apotomo::DatatableWidget, "apotomo-datatable widget" do
  rspecify(self)

  describe ":display event" do
    it "should exclude :id, :created_at and :updated_at by default" do
      @test_controller=test_controller(:widget=>{},:template=>{},:plugin=>{})
      @widget=@test_controller.apotomo_root.childrenHash[:datatable]
      @test_controller.render_widget(:datatable,:display).should_not include("<th>id</th>")
      @test_controller.render_widget(:datatable,:display).should_not include("<th>created_at</th>")
      @test_controller.render_widget(:datatable,:display).should_not include("<th>updated_at</th>")
    end
    it "should include non-rails-default columns default" do
      @test_controller=test_controller(:widget=>{},:template=>{},:plugin=>{})
      @widget=@test_controller.apotomo_root.childrenHash[:datatable]
      @test_controller.render_widget(:datatable,:display).should include("<th>name</th>")
      @test_controller.render_widget(:datatable,:display).should include("<th>value</th>")
    end
    it "should include an excluded column when added to [:template][:included_columns] option" do
      @test_controller=test_controller(:widget=>{},:template=>{:included_columns=>[:id]},:plugin=>{})
      @widget=@test_controller.apotomo_root.childrenHash[:datatable]
      @test_controller.render_widget(:datatable,:display).should include("<th>id</th>")
    end
    it "should exclude additional columns passed in the [:template][:excluded_columns] option" do
      @test_controller=test_controller(:widget=>{},:template=>{:excluded_columns=>[:name]},:plugin=>{})
      @widget=@test_controller.apotomo_root.childrenHash[:datatable]
      @test_controller.render_widget(:datatable,:display).should_not include("<th>name</th>")
    end


  end

end


