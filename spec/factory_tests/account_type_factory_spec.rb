# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
require 'spec_helper'
describe AccountTypeFactory do
  let(:user) { build(:user) }
  let(:result) { AccountTypeFactory.account_type_for(user) }

  it 'returns nil when nothing set' do
    expect(AccountTypeFactory.account_type_for(user)).to be_nil
  end

  describe 'delinquent user' do
    before do
      user.is_delinquent = true
    end
    it 'returns nil on its own' do
      expect(result).to be_nil
    end
    describe 'with unpredictable income' do
      before do
        user.has_predictable_income = false
      end
      it 'returns prepay' do
        expect(result).to eq AccountType.PREPAY_CARD
      end
    end
    describe 'with predictable income' do
      before do
        user.has_predictable_income = true
      end
      it 'returns safe account if in new york city' do
        user.zipcode = '10001'
        expect(result).to eq AccountType.SAFE_ACCOUNT
      end
      it 'returns 2nd chance account otherwise' do
        user.zipcode = '90210'
        pending('2nd chance accounts temporarily sent to prepay cards') do
          expect(result).to eq AccountType.SECOND_CHANCE
        end
      end
      it 'temporarily returns prepay card otherwise' do
        user.zipcode = '90210'
        expect(result).to eq AccountType.PREPAY_CARD
      end
    end
  end

  describe 'non delinquent user' do
    before do
      user.is_delinquent = false
    end
    it 'returns nil on its own' do
      expect(result).to be_nil
    end
    describe 'student' do
      before do
        user.special_group = SpecialGroup.STUDENT
      end
      it 'returns student account' do
        expect(result).to eq AccountType.STUDENT_ACCOUNT
      end
    end
    describe 'student via option set' do
      before do
        user.set_option('special_group', SpecialGroup.STUDENT.name_id)
      end
      it 'returns student account' do
        expect(result).to eq AccountType.STUDENT_ACCOUNT
      end
    end
    describe 'veteran' do
      before do
        user.special_group = SpecialGroup.VETERAN
      end
      it 'returns student account' do
        expect(result).to eq AccountType.VETERANS_ACCOUNT
      end
    end
    describe 'senior' do
      before do
        user.special_group = SpecialGroup.SENIOR
      end
      it 'returns student account' do
        expect(result).to eq AccountType.SENIORS_ACCOUNT
      end
    end
    describe 'special group member' do
      before do
        user.special_group = create(:special_group)
      end
      it 'returns special group account' do
        expect(result).to eq AccountType.SPECIAL_GROUP
      end
    end
    describe 'non special group' do
      before do
        user.special_group = SpecialGroup.NOT_SPECIAL
      end
      it 'returns nil on its own' do
        expect(result).to be_nil
      end
      describe 'will direct deposit paycheck' do
        before do
          user.will_use_direct_deposit = true
        end
        it 'returns regular account' do
          expect(result).to eq AccountType.REGULAR_ACCOUNT
        end
      end
      describe 'not depositing paycheck with direct deposit' do
        before do
          user.will_use_direct_deposit = false
        end

        it 'returns credit union if not in NYC' do
          user.zipcode = '90210'
          expect(result).to eq AccountType.CREDIT_UNION
        end

        describe 'and in NYC' do
          before do
            user.zipcode = '11205'
          end
          it 'returns nil on its own' do
            expect(result).to be_nil
          end
          describe 'needing a debit card' do
            before do
              user.needs_debit_card = true
            end
            it 'returns credit union' do
              expect(result).to eq AccountType.CREDIT_UNION
            end
          end
          describe 'not needing a debit card' do
            before do
              user.needs_debit_card = false
            end
            it 'returns safe account' do
              expect(result).to eq AccountType.SAFE_ACCOUNT
            end
          end
        end
      end
    end
  end
end
