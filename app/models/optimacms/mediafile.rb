module Optimacms

  class Mediafile < ActiveRecord::Base
    self.table_name = 'cms_mediafiles'

    has_attached_file :photo,
                      :styles => { :large=>'800x600>', :medium => "200x150#", :thumb => "150x112#" },
                      :default_url => "/icons/:style/noimage.png",
                      :path => ":rails_root/public/uploads/images/:basename_:style.:extension",
                      :url => "/uploads/images/:basename_:style.:extension"
    # /:class/:attachment
    validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

  end

end

