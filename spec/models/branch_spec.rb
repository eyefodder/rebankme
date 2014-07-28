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
#  street     :string(255)
#  city       :string(255)
#  state      :string(255)
#  zipcode    :string(255)
#  latitude   :float
#  longitude  :float
#

require 'spec_helper'

describe Branch do
  let(:branch){build(:branch)}
  describe 'validations' do
    it 'should require a bank_id' do
      expect(branch).to validate_presence_of(:bank_id)
    end

    it 'should require a name' do
      expect(branch).to validate_presence_of(:name)
    end
    it 'should require a unique name per bank' do
       # expect(branch).to validate_uniqueness_of(:name).scoped_to(:bank_id)
    end
    it 'should require a zipcode' do
      expect(branch).to validate_presence_of(:zipcode)
    end
  end
  describe 'associations' do

    it 'belongs to a bank' do
      expect(branch).to belong_to(:bank)
    end
  end

  describe 'geocoding' do
    before do
      branch.zipcode = '11205' #values in spec helper
      branch.valid?
    end
    it 'should have set the latitude' do
      expect(branch.latitude).to eq 40.6945036 #values in spec helper
    end
    it 'should have set the longitude' do
      expect(branch.longitude).to eq -73.9565551 #values in spec helper
    end
  end

  describe 'full_address' do
    let(:street) {'118 E 10th st'}
    let(:city) {'New York'}
    let(:state) {'NY'}
    it 'handles zip only' do
      expect(branch.full_address).to eq '11205'
    end
    it 'handles street and zip' do
      branch.street = street
      expect(branch.full_address).to eq "#{street}, 11205"
    end
    it 'handles street and city and zip' do
      branch.street = street
      branch.city = city
      expect(branch.full_address).to eq "#{street}, #{city}, 11205"
    end
    it 'handles street and state and zip' do
      branch.street = street
      branch.state = state
      expect(branch.full_address).to eq "#{street}, #{state}, 11205"
    end
  end
end
