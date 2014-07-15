# == Schema Information
#
# Table name: bank_accounts
#
#  id              :integer          not null, primary key
#  account_type_id :integer
#  branch_id       :integer
#  name            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class BankAccount < ActiveRecord::Base
  validates_presence_of :name, :account_type_id, :branch_id
  belongs_to :branch
  belongs_to :account_type


  def self.accounts_near(address, account_type)
    branch_ids = Branch.near(address, 10, order: 'distance').map(&:id)
    where(:branch_id => branch_ids, account_type_id: account_type.id)
  end
end
