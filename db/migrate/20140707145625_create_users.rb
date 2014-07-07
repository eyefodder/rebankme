class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :zipcode
      t.boolean :is_delinquent
      t.boolean :is_special_group
      t.boolean :will_use_direct_deposit
      t.boolean :has_predictable_income
      t.boolean :needs_debit_card

      t.timestamps
    end
  end
end
