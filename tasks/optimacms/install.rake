namespace :optimacms do

  task 'install' do
    Rake::Task["install_assets"].execute

  end

  # This task should be used to copy assets to app/javascript/ of the main
  task 'install_assets' do
    folders = [
        'app/javascript/packs/optimacms',
        'app/javascript/src/optimacms',
        'app/javascript/images/tinymce'

    ]

    folders.each do |d|
      src = File.join(Optimacms::Engine.root, d, '.')
      dst = File.join(Rails.root, d)

      FileUtils.mkdir_p(File.dirname(dst))
      FileUtils.cp_r(src, dst)
    end

  end



  # This task should be used to copy assets to app/javascript/ of the main
  # After it's execution consider to add vendor/modules to resolved paths on
  # webpack configuration.
  task 'old_install_assets' do
    # copy package.json to vendor directory
    src = "#{Optimacms::Engine.root}/package.json"
    dst = "#{Rails.root}/vendor/modules/optimacms/package.json"
    FileUtils.mkdir_p(File.dirname(dst))
    FileUtils.cp(src, dst)

    # copy javascript directory to vendor directory
    src = "#{Optimacms::Engine.root}/app/javascript/optimacms"
    dst = "#{Rails.root}/vendor/modules/optimacms/app/javascript/optimacms"
    FileUtils.mkdir_p(File.dirname(dst))
    FileUtils.cp_r(src, dst)
  end




  desc "Set admin password or create a new admin user"
  task :set_admin_user, [:email, :password] => :environment do |t, args|
    email = args[:email]
    row = Optimacms::CmsAdminUser.where(email: email).first || Optimacms::CmsAdminUser.new(email: email)
    row.password = args[:password]
    row.password_confirmation = args[:password]

    row.save
  end


  desc 'import db'
  task :import_db => :environment do
    #ActiveRecord::Base.connection.execute(IO.read("db-init/gex.sql"))

    # init.sql
    filename = ENV['filename'] || '__db/init.sql'
    script = Rails.root.join(filename).read

    # this needs to match the delimiter of your queries
    statements = script.split /;$/

    ActiveRecord::Base.transaction do
      statements.each do |stmt|
        s = stmt.strip
        #puts "s='#{s}'"

        next if stmt.blank?
        ActiveRecord::Base.connection.execute(stmt)
      end
    end
  end

end
