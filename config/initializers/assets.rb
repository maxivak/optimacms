# yarn
#Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.paths << Optimacms::Engine.root.join('node_modules')


# optimacms
Rails.application.config.assets.precompile += %w( optimacms/bootstrap.css )
Rails.application.config.assets.precompile += %w( optimacms/admin_site.css optimacms/admin.js )


# font-awesome
Rails.application.config.assets.precompile << %r{font-awesome/fonts/[\w-]+\.(?:eot|svg|ttf|woff2?)$}

# tinymce
#Rails.application.config.assets.precompile += %w( tinymce-jquery.js )
Rails.application.config.assets.precompile += %w( optimacms/tinymce.css optimacms/tinymce.js )
#Rails.application.config.assets.precompile += %w( tinymce/plugins/advimage/plugin.js tinymce/plugins/uploadimage/plugin.js tinymce/plugins/uploadimage/langs/en.js )


# ace
Rails.application.config.assets.precompile += %w( optimacms/ace.js )


# elfinder
Rails.application.config.assets.precompile += %w( optimacms/elfinder.css optimacms/elfinder.js )

Rails.application.config.assets.precompile << %r{elfinder-rails/img/.*$}

Rails.application.config.assets.precompile << %r{elfinder-theme-bootstrap/img/.*$}

#Rails.application.config.assets.precompile << %r{elfinder-theme-material/img/.*$}
#Rails.application.config.assets.precompile << %r{elfinder-theme-material/fonts/.*$}

Rails.application.config.assets.precompile << %r{jquery-ui-dist/images/.*$}






