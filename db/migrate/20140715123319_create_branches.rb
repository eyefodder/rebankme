class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.string :name
      t.integer :address_id
      t.string :telephone
      t.string :hours
      t.integer :bank_id

      t.timestamps
    end
  end
end
