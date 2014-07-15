# == Schema Information
#
# Table name: branches
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  address_id :integer
#  telephone  :string(255)
#  hours      :string(255)
#  bank_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Branch do
  let(:branch){build(:branch)}
  describe 'validations' do
    it 'should require a bank_id' do
      expect(branch).to validate_presence_of(:bank_id)
    end
    it 'should require an address_id' do
      expect(branch).to validate_presence_of(:address_id)
    end
    it 'should require a name' do
      expect(branch).to validate_presence_of(:name)
    end
  end
  describe 'associations' do
    it 'has an address' do
      expect(branch).to belong_to(:address)
    end
    it 'belongs to a bank' do
      expect(branch).to belong_to(:bank)
    end
  end
end
