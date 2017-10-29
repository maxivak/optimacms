# sync
namespace :appdata do
  require_relative '../../lib/optimacms/appdata/settings'

  task :check => :environment do
    e = Rails.env
    puts "RAILS_ENV=#{e}"

  end

  # get from remote storage and update the project
  task :update => :environment do
    # input
    content_name = ENV['name']

    #
    content = Optimacms::Appdata::Settings.get_content_info(Rails.env, content_name)
    storage = content['storage']

    #
    if storage['type']=='git'
      Rake::Task["appdata:repo:update"].invoke(content_name)
    elsif storage['type']=='ssh'
      Rake::Task["appdata:ssh:update"].invoke(content_name)
    end

  end

  # save current data to remote storage
  task :save => :environment do
    # input
    content_name = ENV['name']

    #
    content = Optimacms::Appdata::Settings.get_content_info(Rails.env, content_name)
    storage = content['storage']

    #
    if storage['type']=='git'
      Rake::Task["appdata:repo:save"].invoke(content_name)
    elsif storage['type']=='ssh'
      Rake::Task["appdata:ssh:save"].invoke(content_name)
    end

  end


  ### operations with ssh storage

  namespace :ssh do

    task :save, [:name] => :environment do |t, args|
      res = Optimacms::Appdata::Service.save_by_ssh  Rails.env, args[:name]

    end



    task :update, [:name] => :environment do |t, args|
      res = Optimacms::Appdata::Service.update_by_ssh  Rails.env, args[:name]

    end
  end


  ### operations with git storage

  namespace :repo do

    task :save, [:name] => :environment do |t, args|
      # setup
      res = Optimacms::Appdata::Service.content_setup_git Rails.env, args[:name]

      # save
      res = Optimacms::Appdata::Service.save_by_git  Rails.env, args[:name]

    end


    task :update, [:name] => :environment do |t, args|

      # setup
      res = Optimacms::Appdata::Service.content_setup_git Rails.env, args[:name]

      # update
      res = Optimacms::Appdata::Service.update_by_git  Rails.env, args[:name]

    end


    task :setup => :environment do
      #
      res = Optimacms::Appdata::Service.content_setup_git Rails.env, args[:name]

    end



  end



end
