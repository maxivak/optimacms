namespace :optimacms do
namespace :install do

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
end
