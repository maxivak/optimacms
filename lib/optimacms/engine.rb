
module Optimacms
  class Engine < ::Rails::Engine
    isolate_namespace Optimacms


    #config.to_prepare do
    #  Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
    #    require_dependency(c)
    #  end
    #end

    # for Rails 5
    config.enable_dependency_loading = false
    #config.eager_load_paths += %W( #{Optimacms::Engine.root}/lib/optimacms.rb #{Optimacms::Engine.root}/lib/version.rb #{Optimacms::Engine.root}/lib/mycontroller.rb)
    config.eager_load_paths += %W( #{Optimacms::Engine.root}/lib )


    config.watchable_dirs['lib'] = [:rb] if Rails.env.development?
    config.watchable_dirs['app/helpers'] = [:rb] if Rails.env.development?

    #config.autoload_paths << File.expand_path("../lib/some/path", __FILE__)
    #config.autoload_paths << File.expand_path("../lib/optimacms/path", __FILE__)

    config.autoload_paths += Dir["#{Optimacms::Engine.root}/app/helpers/"]
    config.autoload_paths += Dir["#{Optimacms::Engine.root}/app/helpers/optimacms/"]
    config.autoload_paths += Dir["#{Optimacms::Engine.root}/app/helpers/simple_filter/"]
    config.autoload_paths += Dir["#{Optimacms::Engine.root}/app/helpers/**/"]

    config.autoload_paths += Dir["#{Optimacms::Engine.root}/lib/"]
    config.autoload_paths += Dir["#{Optimacms::Engine.root}/lib/**/"]

    #config.autoload_paths += Dir["#{Optimacms::Engine.root}/lib/concerns/"]
    #config.autoload_paths += Dir["#{Optimacms::Engine.root}/lib/concerns/**/"]

    config.autoload_paths += Dir["#{Optimacms::Engine.root}/lib/optimacms/"]
    config.autoload_paths += Dir["#{Optimacms::Engine.root}/lib/optimacms/**/"]
    config.autoload_paths += Dir["#{Optimacms::Engine.root}/lib/optimacms/common/*.rb"]
    config.autoload_paths += Dir["#{Optimacms::Engine.root}/lib/optimacms/page_services/*.rb"]

    #config.autoload_paths += Dir["#{config.root}/lib/**/"]
    #config.autoload_paths += Dir["#{config.root}/lib/"]
    #config.autoload_paths += Dir["#{config.root}/lib/**/*.rb"]



    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end


    config.before_initialize do
      ActiveSupport.on_load :action_controller do
        include ::Optimacms::Mycontroller

        ::ActionController::Base.helper Optimacms::Engine.helpers
      end
    end

    initializer "optimacms assets precompile" do |app|

      app.config.assets.precompile += %w(admin.css admin.js optimacms/admin.css optimacms/admin.js optimacms/tinymce.css optimacms/tinymce.js  optimacms/ace.js optimacms/elfinder.css optimacms/elfinder.js)


    end

  end
end
