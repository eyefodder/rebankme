class RenameLine1OnAddresses < ActiveRecord::Migration
  def change
    rename_column :addresses, :line_1, :street
    remove_column :addresses, :line_2
  end
end
