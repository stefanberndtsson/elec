class AddColumnToItems < ActiveRecord::Migration
  def change
    add_column :items, :checksum, :text
  end
end
