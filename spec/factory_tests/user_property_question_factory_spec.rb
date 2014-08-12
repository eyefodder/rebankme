# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
require 'spec_helper'

describe UserPropertyQuestionFactory do
  let(:user) { build(:user) }
  let(:factory) { UserPropertyQuestionFactory }

  describe '#next_property_for(user)' do
    it 'returns :is_delinquent first' do
      expect(factory.next_property_for(user)).to eq(:is_delinquent)
    end

    describe 'is_delinquent: true' do
      before do
        user.is_delinquent = true
      end
      it 'returns :has_predictable_income' do
        expect(factory.next_property_for(user)).to eq(:has_predictable_income)
      end
    end

    describe 'is_delinquent: false' do
      before do
        user.is_delinquent = false
      end
      it 'returns :is_special_group ' do
        expect(factory.next_property_for(user)).to eq(:special_group)
      end

      describe ':NOT_SPECIAL' do
        before do
          user.special_group = SpecialGroup.NOT_SPECIAL
        end
        it 'returns :will_use_direct_deposit' do
          result = factory.next_property_for(user)
          expect(result).to eq(:will_use_direct_deposit)
        end
        describe 'will_use_direct_deposit: false' do
          before do
            user.will_use_direct_deposit = false
          end
          it 'returns :needs_debit_card'  do
            expect(factory.next_property_for(user)).to eq(:needs_debit_card)
          end

        end
      end
    end
  end

end
