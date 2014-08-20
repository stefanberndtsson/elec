class RemoveColumnsFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :filename
    remove_column :items, :path
    remove_column :items, :checksum
  end
end
