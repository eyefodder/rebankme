require 'spec_helper'



describe UserPropertyQuestionFactory do
    let(:user){build(:user)}
    let(:factory){UserPropertyQuestionFactory}

    describe '#next_property_for(user)' do
    it 'returns :is_delinquent first' do
      expect(factory.next_property_for(user)).to eq(:is_delinquent)
    end

    it 'returns :has_predictable_income if :is_delinquent is true' do
      user.is_delinquent = true
      expect(factory.next_property_for(user)).to eq(:has_predictable_income)
    end
    it 'returns :is_special_group if :is_delinquent is false' do
      user.is_delinquent = false
      expect(factory.next_property_for(user)).to eq(:is_special_group)
    end
    it 'returns :will_use_direct_deposit if :is_delinquent -> false and :is_special_group -> false' do
      user.is_delinquent = false
      user.is_special_group = false
      expect(factory.next_property_for(user)).to eq(:will_use_direct_deposit)
    end
    it 'returns :needs_debit_card if :is_delinquent, :is_special_group and :will_use_direct_deposit all false' do
      user.is_delinquent = false
      user.is_special_group = false
      user.will_use_direct_deposit = false
      expect(factory.next_property_for(user)).to eq(:needs_debit_card)
    end
  end

end