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
end
end
