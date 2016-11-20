class AddAttachmentPhotoToMediafiles < ActiveRecord::Migration
  def self.up
    change_table :cms_mediafiles do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :cms_mediafiles, :photo
  end
end
