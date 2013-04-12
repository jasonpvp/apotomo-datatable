#http://rakeroutes.com/blog/write-a-gem-for-the-rails-asset-pipeline/
module ApotomoDatatable
  class Engine < Rails::Engine
    initializer 'apotomo-datatable.load_static_assets' do |app|
#      app.config.assets.paths << "#{root}/vendor/assets"
#      app.middleware.use ::ActionDispatch::Static, "#{root}/vendor/assets"
#      app.middleware.insert_before(::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/vendor")
#      app.middleware.insert_before ::Rack::Lock, ::ActionDispatch::Static, "#{root}/vendor"
      File.open('/tmp/a','w') {|f| f.write("should be loading assets from #{app.config.assets.paths}\n")}
    end
  end
end
