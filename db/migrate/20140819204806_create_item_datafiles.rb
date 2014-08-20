class CreateItemDatafiles < ActiveRecord::Migration
  def change
    create_table :item_datafiles do |t|
      t.integer :item_id
      t.integer :datafile_id

      t.timestamps
    end
  end
end
