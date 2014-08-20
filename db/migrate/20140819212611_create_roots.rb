class CreateRoots < ActiveRecord::Migration
  def change
    create_table :roots do |t|
      t.text :path

      t.timestamps
    end
  end
end
