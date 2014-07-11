# == Schema Information
#
# Table name: account_types
#
#  id         :integer          not null, primary key
#  name_id    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'
include Il8nSteps

shared_examples "a predefined type" do
  it 'exists' do
    expect(account_type).to_not be_nil
    expect(account_type).to be_an(AccountType)
  end
  it 'has a name id' do
    expect(account_type.name_id).to eq name_id
  end

  it 'has a value for the name' do
    there_should_be_a_translation_for("#{account_type.name_id}.name")
  end
end

describe AccountType do
  let(:account_type){build(:account_type)}
  it 'should require a name' do
    expect(account_type).to validate_presence_of(:name_id)
  end
  it 'should require a unique name' do
    expect(account_type).to validate_uniqueness_of(:name_id)
  end

  describe 'seeded account types' do
    describe 'prepay card' do
      let(:account_type){AccountType.PREPAY_CARD}
      it_behaves_like 'a predefined type' do
        let(:name_id) {'prepay_card'}
      end
    end
    describe 'second chance account' do
      let(:account_type){AccountType.SECOND_CHANCE}
      let(:name_id) {'second_chance'}
      it_behaves_like 'a predefined type'
    end
    describe 'safe account' do
      let(:account_type){AccountType.SAFE_ACCOUNT}
      let(:name_id) {'safe_account'}
      it_behaves_like 'a predefined type'
    end

    describe 'special group account' do
      let(:account_type){AccountType.SPECIAL_GROUP}
      let(:name_id) {'special_group'}
      it_behaves_like 'a predefined type'
    end

    describe 'special group account' do
      let(:account_type){AccountType.REGULAR_ACCOUNT}
      let(:name_id) {'regular_account'}
      it_behaves_like 'a predefined type'
    end

    describe 'special group account' do
      let(:account_type){AccountType.CREDIT_UNION}
      let(:name_id) {'credit_union'}
      it_behaves_like 'a predefined type'
    end
  end
end




