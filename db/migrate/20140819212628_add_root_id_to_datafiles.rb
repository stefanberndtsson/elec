class AddRootIdToDatafiles < ActiveRecord::Migration
  def change
    add_column :datafiles, :root_id, :integer
  end
end
