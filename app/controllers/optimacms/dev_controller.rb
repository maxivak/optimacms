module Optimacms
  class DevController < ApplicationController

    before_filter :check_env

    def check_env
      return false unless Rails.env.development?
    end

    def file
      from = 'D:/mmx/projects/www/myrails/cms/site/test/dummy/public/files/1/cat_red.jpg'
      to = 'D:/mmx/projects/www/myrails/cms/site/test/dummy/public/files/1/supercat.jpg'

      f = 'D:/mmx/projects/www/myrails/cms/site/test/dummy/public/uploads/funny-cats-and-kittens-wallpapers-12.jpg'


      #FileUtils.move(from, to)

      require 'pathname'
      p = Pathname.new(f)
      p.unlink

      #FileUtils.rm(f)
    end

    def addadminuser
      #return

      row = Optimacms::CmsAdminUser.where(email: 'admin@example.com').first || Optimacms::CmsAdminUser.new
      row.email = 'admin@example.com'
      row.password = 'password'
      row.password_confirmation = row.password

      row.save!
    end

    def url1
      v = '[a-z\d\_]+'

      p = '(:pg)'
      p.gsub! /(\(\:#{v}\))([-\.]|$)/, '([^/]+|)\2'

      x = 0

    end

    def url2
      u = "news/3"
      r = /^news\/([^\/]+|)$/

      if u =~ /^news(\/.*|)$/

        x = $1
        y = $2

        z=0

      end
    end
  end



end

