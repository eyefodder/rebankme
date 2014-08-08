require 'spec_helper'

describe GoogleSearchTermFactory do
  let(:user) {build(:user)}

  describe '.map_search_term_for' do
    let(:result) {GoogleSearchTermFactory.map_search_term_for(account_type, user)}

    describe 'safe account' do
      let(:account_type){AccountType.SAFE_ACCOUNT}
      it 'returns nil' do
        expect(result).to be_nil
      end
    end

    describe 'Prepaid card' do
      let(:account_type) {AccountType.PREPAY_CARD}
      it 'returns nil' do
        expect(result).to be_nil
      end
    end

    describe 'Credit Union' do
      let(:account_type) {AccountType.CREDIT_UNION}
      it 'returns term' do
        expect(result).to eq "Credit Unions near #{user.zipcode}"
      end
    end

    describe 'Regular Account' do
      let(:account_type) {AccountType.REGULAR_ACCOUNT}
      it 'returns term' do
        expect(result).to eq "Free Checking near #{user.zipcode}"
      end
    end
    describe 'STUDENT_ACCOUNT' do
      let(:account_type) {AccountType.STUDENT_ACCOUNT}
      it 'returns term' do
        expect(result).to eq "Free Student Checking near #{user.zipcode}"
      end
    end

    describe 'seniors' do
      let(:account_type) {AccountType.SENIORS_ACCOUNT}
      describe "in USBank states" do
        before do
          user.state =  State.find_by(code: 'ID')
          user.save!(validate: false)
        end
        it 'returns term' do
          expect(result).to eq "USBank Branches near #{user.zipcode}"
        end
      end

      describe 'non USBank states' do
        before do
          user.state =  State.find_by(code: 'NY')
          user.save!(validate: false)
        end
        it 'returns term' do
          expect(result).to eq "Credit Unions near #{user.zipcode}"
        end
      end
    end

    describe 'veterans' do
      let(:account_type) {AccountType.VETERANS_ACCOUNT}
      describe 'chase state' do
        before do
          user.state =  State.find_by(code: 'NY')
          user.save!(validate: false)
        end
        it 'returns term' do
          expect(result).to eq "Chase Branches near #{user.zipcode}"
        end
      end

      describe 'non chase state' do
        before do
          user.state =  State.find_by(code: 'AL')
          user.save!(validate: false)
        end
        it 'returns nil' do
          expect(result).to be_nil
        end
      end


    end

  end
end