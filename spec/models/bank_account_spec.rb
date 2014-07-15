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

require 'spec_helper'

describe BankAccount do
  let(:bank_account){build(:bank_account)}
  describe 'validations' do
    it 'should require a account_type_id' do
      expect(bank_account).to validate_presence_of(:account_type_id)
    end
    it 'should require an branch_id' do
      expect(bank_account).to validate_presence_of(:branch_id)
    end
    it 'should require a name' do
      expect(bank_account).to validate_presence_of(:name)
    end
  end
  describe 'associations' do
    it 'has a branch' do
      expect(bank_account).to belong_to(:branch)
    end
    it 'belongs to an account type' do
      expect(bank_account).to belong_to(:account_type)
    end
  end
end
