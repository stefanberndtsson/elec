class AddChecksumToItemTags < ActiveRecord::Migration
  def change
    add_column :item_tags, :checksum, :text
  end
end
