require 'el_finder/action'

module Optimacms
  class ElfinderController < ApplicationController
    skip_before_action :verify_authenticity_token, :only => ['elfinder']

    def index
       render :layout => false
    end

    def elfinder
      dirpath = Optimacms.files_dir_path
      rootpath = File.join(Rails.public_path, dirpath)
      rooturl = '/'+dirpath

      h, r = ElFinder::Connector.new(
        :root => rootpath,
        :url => rooturl,
        :perms => {
           #/^(Welcome|README)$/ => {:read => true, :write => false, :rm => false},
           '.' => {:read => true, :write => true, :rm => true}, # '.' is the proper way to specify the home/root directory.
           #/^test$/ => {:read => true, :write => true, :rm => false},
           #'logo.png' => {:read => true},
           #/\.png$/ => {:read => false} # This will cause 'logo.png' to be unreadable.
           # Permissions err on the safe side. Once false, always false.
        },
        :thumbs => true
      ).run(params)

      headers.merge!(h)

      if r.empty?
        (render :nothing => true) and return
      end

      render :json => r, :layout => false
    end
  end
end
