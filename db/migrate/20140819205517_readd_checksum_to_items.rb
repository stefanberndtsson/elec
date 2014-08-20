class ReaddChecksumToItems < ActiveRecord::Migration
  def change
    add_column :items, :checksum, :text
    remove_column :datafiles, :checksum
  end
end
