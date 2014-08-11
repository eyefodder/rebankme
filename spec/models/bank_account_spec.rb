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
  describe '.accounts_near' do
    let(:oregon_user){create(:user, latitude: 44.0, longitude: -121.6724376, zipcode: '97206')}
    let(:bronx_user){create(:user, latitude: 40.8803247, longitude: -73.9095279, zipcode: '10463')}
    let(:brooklyn_user){create(:user, latitude: 40.6945036, longitude: -73.9565551, zipcode: '11205')}
    let(:bronx_branch) {create(:branch, latitude: 40.8522159, longitude: -73.907912, zipcode: '10453')}
    let(:brooklyn_branch) {create(:branch, latitude: 40.6945036, longitude: -73.9565551, zipcode: '11237')}
    let(:beverly_hills_branch) {create(:branch, latitude: 34.1030032, longitude: -118.4104684, zipcode: '90210')}
    let(:brooklyn_safe_account) {create(:bank_account, account_type: AccountType.SAFE_ACCOUNT, branch: brooklyn_branch, name: 'brooklyn safe account')}
    let(:brooklyn_prepay_account) {create(:bank_account, account_type: AccountType.PREPAY_CARD, branch: brooklyn_branch, name: 'brooklyn prepay account')}
    let(:bronx_safe_account) {create(:bank_account, account_type: AccountType.SAFE_ACCOUNT, branch: bronx_branch, name: 'bronx safe account')}
    # let!(:bronx_prepay_account) {create(:bank_account, account_type: AccountType.PREPAY_CARD, branch: bronx_branch, name: 'bronx prepay account')}
    let(:beverly_hills_safe_account) {create(:bank_account, account_type: AccountType.SAFE_ACCOUNT, branch: beverly_hills_branch, name: 'bev hills safe account')}

    before do
      #@XXX was getting some nasty issues with db not getting cleared out, so this way, we endure all branches
      #     destroyed, then create the accounts, instead of using let!
      Branch.destroy_all
      brooklyn_safe_account
      brooklyn_prepay_account
      bronx_safe_account
      beverly_hills_safe_account
    end

    it 'returns an empty array if nothing nearby' do
      results = BankAccount.accounts_near(oregon_user, AccountType.SAFE_ACCOUNT)
      expect(results.length).to eq 0
    end

    it 'only includes specified account types' do
      results = BankAccount.accounts_near(brooklyn_user, AccountType.SAFE_ACCOUNT)
      expect(results).to include brooklyn_safe_account
      expect(results).not_to include brooklyn_prepay_account
    end

    it 'only includes accounts within 20 miles' do
      results = BankAccount.accounts_near(brooklyn_user, AccountType.SAFE_ACCOUNT)
      expect(results).not_to include beverly_hills_safe_account
    end
    describe 'orders the results closest first' do
      it 'shows brooklyn first for a brooklyn user' do
        results = BankAccount.accounts_near(brooklyn_user, AccountType.SAFE_ACCOUNT)
        expect(results.first).to eq brooklyn_safe_account
      end
      it 'shows bronx first for a bronx user' do
        results = BankAccount.accounts_near(bronx_user, AccountType.SAFE_ACCOUNT)
        expect(results.first).to eq bronx_safe_account
      end

    end

  end
end
