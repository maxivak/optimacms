class AddIndexNameToPages < ActiveRecord::Migration

  def up
    add_index :cms_pages, :name

  end

  def down
    remove_index :cms_pages, :name
  end
end
