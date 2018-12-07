namespace :optimacms do
namespace :users do

  desc "Set password"
  task :set_password, [:login, :password] => :environment do |t, args|
    login = args[:login]
    row = Optimacms::CmsAdminUser.where("email = ? or username = ?", login, login).first

    raise 'User not found' if row.nil?

    # change
    row.password = args[:password]
    row.password_confirmation = args[:password]

    row.save!
  end


  desc "Create a new admin user"
  task :create_admin_user, [:login, :email, :password] => :environment do |t, args|
    login = args[:login]

    row = Optimacms::CmsAdminUser.where(username: login).first

    raise 'User already exists' unless row.nil?

    # create
    row = Optimacms::CmsAdminUser.new(username: login, email: args[:email])
    row.password = args[:password]
    row.password_confirmation = args[:password]

    row.save!
  end


  desc "remove user"
  task :remove, [:login] => :environment do |t, args|
    login = args[:login]
    row = Optimacms::CmsAdminUser.where("email = ? or username = ?", login, login).first

    raise 'User not found' if row.nil?

    # change
    row.destroy!
  end



end
end
