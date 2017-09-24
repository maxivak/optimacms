class FixPagesParent < ActiveRecord::Migration[5.1]
  def self.up
    Optimacms::Page.where("parent_id=0").update_all("parent_id=null")
  end

  def self.down
  end
end
