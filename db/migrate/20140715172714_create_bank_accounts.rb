class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.integer :account_type_id
      t.integer :branch_id
      t.string :name

      t.timestamps
    end
  end
end
