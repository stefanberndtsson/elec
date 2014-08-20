class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.text :name
      t.text :filename
      t.text :path

      t.timestamps
    end
  end
end
