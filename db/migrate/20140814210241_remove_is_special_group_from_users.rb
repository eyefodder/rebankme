class RemoveIsSpecialGroupFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :is_special_group
  end
end
