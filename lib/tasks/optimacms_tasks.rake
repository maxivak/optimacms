# desc "Explaining what the task does"
# task :optimacms do
#   # Task goes here
# end


namespace :optimacms do
  desc "Set admin password or create a new admin user"
  task :create_admin_user, [:email, :password] => :environment do |t, args|
    email = args[:email]
    row = Optimacms::CmsAdminUser.where(email: email).first || Optimacms::CmsAdminUser.new(email: email)
    row.password = args[:password]
    row.password_confirmation = args[:password]

    row.save
  end
end
