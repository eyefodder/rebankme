class CreateSpecialGroups < ActiveRecord::Migration
  def change
    create_table :special_groups do |t|
      t.string :name_id

      t.timestamps
    end
  end
end
