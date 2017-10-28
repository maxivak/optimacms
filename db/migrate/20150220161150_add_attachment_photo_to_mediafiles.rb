class AddAttachmentPhotoToMediafiles < ActiveRecord::Migration[5.1]
  def self.up
    change_table :cms_mediafiles do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :cms_mediafiles, :photo
  end
end
