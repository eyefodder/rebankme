class AddSpecialGroupIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :special_group_id, :integer
  end
end
