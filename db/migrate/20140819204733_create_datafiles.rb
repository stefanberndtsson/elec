class CreateDatafiles < ActiveRecord::Migration
  def change
    create_table :datafiles do |t|
      t.text :filename
      t.text :path
      t.text :checksum

      t.timestamps
    end
  end
end
