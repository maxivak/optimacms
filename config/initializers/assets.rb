# yarn
Rails.application.config.assets.paths << Rails.root.join('node_modules')

Rails.application.config.assets.precompile << %r{font-awesome/fonts/[\w-]+\.(?:eot|svg|ttf|woff2?)$}


#
#Rails.application.config.assets.precompile += %w( bootstrap4/bootstrap.css )

Rails.application.config.assets.precompile += %w( tinymce-jquery.js )
Rails.application.config.assets.precompile += %w( optimacms/tinymce.css )
Rails.application.config.assets.precompile += %w( tinymce/plugins/advimage/plugin.js tinymce/plugins/uploadimage/plugin.js tinymce/plugins/uploadimage/langs/en.js )

Rails.application.config.assets.precompile += %w( optimacms/admin_site.css optimacms/admin.js )
